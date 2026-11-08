// Execute compiled Augment actions with controlled inputs and wait completions.
// This is a focused Workshop interpreter, not an emulation of Overwatch physics.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {files, compile, compiler, src} = require('./measure-further-optimizations.cjs');
const {rules} = require('./verify-player-variables.cjs');
const {args} = require('./verify-global-temporaries.cjs');
const root = path.dirname(src);
const enhancementCount = Math.max(...[...files['variables.opy'].match(/enum Enhancement:([\s\S]*?)\n\n/)[1].matchAll(/= (\d+),/g)].map(m => Number(m[1])));
const slot = name => files['variables.opy'].match(new RegExp('^#!define ' + name + ' (\\w+)$', 'm'))[1];
const truth = value => Array.isArray(value) ? value.length > 0 : !!value;
const array = value => Array.isArray(value) ? value : value ? [value] : [];
const equal = (left, right) => Array.isArray(left) || Array.isArray(right)
    ? Array.isArray(left) && Array.isArray(right) && left.length === right.length && left.every((x, i) => equal(x, right[i]))
    : typeof left === 'object' || typeof right === 'object' || typeof left === 'string' || typeof right === 'string' ? left === right : Number(left) === Number(right);
const point = object => Array.isArray(object) ? object : object.position;
const magnitude = vector => Math.hypot(...vector);
const angle = (a, b) => Math.acos(Math.max(-1, Math.min(1,
    a.reduce((sum, x, i) => sum + x * b[i], 0) / (magnitude(a) * magnitude(b))))) * 180 / Math.PI;

// Split top-level emitted infix conditions, respecting parentheses and quoted strings.
function infix(expr, operators) {
    let depth = 0, quoted = false;
    for (let i = 0; i < expr.length; i++) {
        if (quoted && expr[i] === '\\') { i++; continue; }
        if (expr[i] === '"') quoted = !quoted;
        if (quoted) continue;
        if (expr[i] === '(') depth++;
        if (expr[i] === ')') depth--;
        if (!depth) for (const op of operators) if (expr.startsWith(op, i)) {
            return [expr.slice(0, i).trim(), op, expr.slice(i + op.length).trim()];
        }
    }
}

function value(expr, state, element) {
    expr = expr.trim();
    for (const operators of [['&&', '||'], ['==', '!=', '>=', '<=', '>', '<']]) {
        const parts = infix(expr, operators);
        if (parts) {
            const left = value(parts[0], state, element), right = value(parts[2], state, element);
            switch (parts[1]) {
                case '&&': return truth(left) && truth(right);
                case '||': return truth(left) || truth(right);
                case '==': return equal(left, right);
                case '!=': return !equal(left, right);
                case '>=': return left >= right;
                case '<=': return left <= right;
                case '>': return left > right;
                case '<': return left < right;
            }
        }
    }
    if (expr.startsWith('(') && expr.endsWith(')')) return value(expr.slice(1, -1), state, element);
    if (/^-?\d+(?:\.\d+)?$/.test(expr)) return Number(expr);
    if (expr === 'True') return true;
    if (expr === 'False' || expr === 'Null') return 0;
    if (expr === 'Empty Array') return [];
    if (expr === 'Up') return [0, 1, 0];
    if (expr === 'Forward') return [0, 0, 1];
    if (expr === 'Left') return [1, 0, 0];
    if (expr === 'Right') return [-1, 0, 0];
    if (expr === 'Total Time Elapsed') return state.time;
    if (expr === 'Last Created Entity') return state.lastEntity;
    if (expr === 'Team 2') return 2;
    if (expr === 'Event Player' || expr === 'Local Player') return state.player;
    if (expr === 'Victim') return state.victim;
    if (expr === 'Event Ability') return state.eventAbility ?? 0;
    if (expr === 'Event Damage') return state.eventDamage ?? 0;
    if (expr === 'Event Healing') return state.eventHealing;
    if (expr === 'Healer') return state.healer ?? 0;
    if (expr === 'Event Was Health Pack') return state.eventWasHealthPack;
    if (expr === 'Match Time') return state.matchTime;
    if (expr === 'Current Array Element') return element;
    if (expr === 'Current Array Index') return state.arrayIndex;
    if (expr.startsWith('Global.')) return state.globals[expr.slice(7)] ?? 0;
    const field = expr.match(/^\((.+)\)\.(\w+)$/);
    if (field) return value(field[1], state, element)[field[2]] ?? 0;
    if (expr.startsWith('"')) return JSON.parse(expr);
    const name = expr.slice(0, expr.indexOf('(')), a = args(expr);
    const v = i => value(a[i], state, element);
    switch (name) {
        case 'Button': case 'Hero': return a[0];
        case 'Icon String': assert.equal(a[0], 'Checkmark'); return '✓';
        case 'Array': return a.map(item => value(item, state, element));
        case 'Vector': return a.map(item => Number(value(item, state, element)));
        case 'X Component Of': return v(0)[0];
        case 'Z Component Of': return v(0)[2];
        case 'First Of': return array(v(0))[0] ?? 0;
        case 'Count Of': return array(v(0)).length;
        case 'Array Slice': return array(v(0)).slice(Number(v(1)), Number(v(1)) + Number(v(2)));
        // Deterministic shuffle fixture: native RNG distribution is outside this interpreter.
        case 'Randomized Array': state.shuffleCalls = (state.shuffleCalls ?? 0) + 1; return [...array(v(0))];
        case 'Value In Array': return array(v(0))[Number(v(1))] ?? 0;
        case 'Append To Array': return array(v(0)).concat(v(1));
        case 'Remove From Array': return array(v(0)).filter(item => !array(v(1)).includes(item));
        case 'Nearest Walkable Position': return state.walkablePosition ?? point(v(0));
        case 'If-Then-Else': return truth(v(0)) ? v(1) : v(2);
        case 'Evaluate Once': return v(0);
        case 'Filtered Array': return array(v(0)).filter(item => truth(value(a[1], state, item)));
        case 'Mapped Array': return array(v(0)).map((item, index) => {
            const outer = state.arrayIndex;
            state.arrayIndex = index;
            try { return value(a[1], state, item); }
            finally { state.arrayIndex = outer; }
        });
        case 'Sorted Array': return [...array(v(0))].sort((left, right) =>
            value(a[1], state, left) - value(a[1], state, right));
        case 'Array Contains': return array(v(0)).includes(v(1));
        case 'Index Of Array Value': return array(v(0)).indexOf(v(1));
        case 'Add': {
            const left = v(0), right = v(1);
            return Array.isArray(left) ? left.map((x, i) => x + right[i]) : Number(left) + Number(right);
        }
        case 'Subtract': {
            const left = v(0), right = v(1);
            return Array.isArray(left) ? left.map((x, i) => x - right[i]) : Number(left) - Number(right);
        }
        case 'Multiply': {
            const left = v(0), right = v(1);
            return Array.isArray(left) ? left.map(x => x * right) : Array.isArray(right) ? right.map(x => left * x) : left * right;
        }
        case 'Modulo': return v(0) % v(1);
        case 'Max': return Math.max(v(0), v(1));
        case 'Min': return Math.min(v(0), v(1));
        case 'Divide': return v(0) / v(1);
        case 'Absolute Value': return Math.abs(v(0));
        case 'And': return truth(v(0)) && truth(v(1));
        case 'Or': return truth(v(0)) || truth(v(1));
        case 'Not': return !truth(v(0));
        case 'Compare': return value(a[0] + ' ' + a[1] + ' ' + a[2], state, element);
        case 'Is Alive': return v(0) === state.player ? state.alive : v(0).alive;
        case 'Is Dead': return !(v(0) === state.player ? state.alive : v(0).alive);
        case 'Has Spawned': return state.spawned;
        case 'Is Dummy Bot': return v(0) === state.player ? state.dummy : !!v(0).dummy;
        case 'Is On Ground': return v(0) === state.player ? state.ground : v(0).ground;
        case 'Is Button Held': return state.buttons.has(v(1));
        case 'Throttle Of': return state.throttle;
        case 'Magnitude Of': return magnitude(v(0));
        case 'Normalize': { const vector = v(0), length = magnitude(vector); return vector.map(x => length ? x / length : 0); }
        case 'Angle Between Vectors': return angle(v(0), v(1));
        case 'Hero Of': return v(0) === state.player ? state.hero : v(0).hero ?? state.hero;
        case 'Horizontal Facing Angle Of': case 'Horizontal Facing Angle': return state.yaw;
        case 'Horizontal Angle From Direction': {const vector = v(0); return Math.atan2(vector[0], vector[2]) * 180 / Math.PI;}
        case 'Direction From Angles': {
            const yaw = v(0) * Math.PI / 180, pitch = v(1) * Math.PI / 180;
            return [Math.sin(yaw) * Math.cos(pitch), -Math.sin(pitch), Math.cos(yaw) * Math.cos(pitch)];
        }
        case 'Weapon': return state.weapon;
        case 'Ammo': return state.ammo[Number(v(1))];
        case 'Max Ammo': return state.maxAmmo[Number(v(1))];
        case 'Is Meleeing': return state.meleeing;
        case 'Is Firing Primary': return state.firing;
        case 'Is Firing Secondary': return state.blocking;
        case 'Is Using Ultimate': return state.ultimate;
        case 'Is Reloading': return state.reloading;
        case 'Is In Alternate Form': return state.alternateForm;
        case 'Ultimate Charge Percent': return state.ultCharge;
        case 'Is True For All': return array(v(0)).every(item => truth(value(a[1], state, item)));
        case 'Is True For Any': return array(v(0)).some(item => truth(value(a[1], state, item)));
        case 'Health': return v(0).health ?? 10000;
        case 'Is Using Ability 1': return state.ability1 ?? state.ability;
        case 'Is Using Ability 2': return state.ability2 ?? state.ability;
        case 'Max Health Of Type': assert.equal(a[1], 'Armor'); return state.maxArmor;
        case 'Has Status': return (v(0) === state.player ? state.status : v(0).status ?? state.status).has(a[1]);
        case 'Entity Exists': return !!v(0) && v(0).exists !== false;
        case 'Normalized Health': return v(0).health / v(0).maxHealth;
        case 'Ray Cast Hit Player': state.raycastCalls = (state.raycastCalls ?? 0) + 1; return state.raycastTarget ?? 0;
        case 'Eye Position': return point(v(0)).map((x, i) => x + (i === 1 ? 1.5 : 0));
        case 'Facing Direction Of': return state.facing;
        case 'All Players': return [state.player, ...state.targets];
        case 'Position Of': return point(v(0));
        case 'Velocity Of': return state.velocity;
        case 'Team Of': return v(0).team ?? 2;
        case 'Direction Towards': {
            const delta = point(v(1)).map((x, i) => x - point(v(0))[i]), length = magnitude(delta);
            return delta.map(x => length ? x / length : 0);
        }
        case 'Is In Line of Sight': return state.lineOfSight;
        case 'Distance Between': return magnitude(point(v(0)).map((x, i) => x - point(v(1))[i]));
        case 'Players Within Radius':
            assert.equal(a[2], 'Team 2'); assert.equal(a[3], 'Surfaces');
            return state.targets.filter(target => (target.team ?? 2) === 2 && target.visible && magnitude(target.position.map((x, i) => x - point(v(0))[i])) <= v(1));
        case 'Is In View Angle': return angle(state.facing, v(1).map((x, i) => x - value('Eye Position(Event Player)', state)[i])) <= v(2);
        case 'Random Integer': {
            const min = Number(v(0)), max = Number(v(1)), roll = state.randomRolls?.shift() ?? state.randomRoll ?? min;
            assert(Number.isInteger(roll) && roll >= min && roll <= max);
            state.randomCalls.push([min, max]);
            return roll;
        }
        case 'Custom String': return v(0).replace(/\{(\d+)\}/g, (_, index) => v(Number(index) + 1));
        case 'Round To Integer': assert.equal(a[1], 'Up'); return Math.ceil(v(0));
        default: throw new Error('Unsupported expression: ' + expr);
    }
}

const conditions = rule => rule.body.match(/conditions \{\n([\s\S]*?)\n\}/)?.[1].split('\n').map(line => line.slice(0, -1)) ?? [];
const actions = rule => rule.body.split('actions {\n')[1].replace(/\n\}$/, '').split('\n');
const applies = (rule, state) => conditions(rule).every(expr => truth(value(expr, state)));

function* execute(rule, state, compiled) {
    const lines = actions(rule);
    const blockEnd = start => {
        let depth = 1, end = start;
        while (depth && ++end < lines.length) {
            if (/^(If|While|For Player Variable|For Global Variable)\(/.test(lines[end])) depth++;
            if (lines[end] === 'End;') depth--;
        }
        assert.equal(depth, 0, 'Unclosed control block');
        return end;
    };
    let branches = [];
    const active = () => branches.every(branch => branch.active);
    for (let pc = 0; pc < lines.length; pc++) {
        const line = lines[pc], name = line.slice(0, line.indexOf('('));
        if (line === 'Else;') {
            const branch = branches.at(-1); branch.active = branch.parent && !branch.taken; branch.taken = true;
        } else if (line === 'End;') {
            const branch = branches.at(-1);
            assert(branch);
            if (branch.kind === 'for') {
                const owner = branch.global ? state.globals : state.player;
                owner[branch.field] += branch.step;
                if (owner[branch.field] < branch.limit) pc = branch.start;
                else branches.pop();
            } else if (branch.kind === 'while' && truth(value(branch.predicate, state))) pc = branch.start;
            else branches.pop();
        } else if (name === 'If') {
            const parent = active(), selected = parent && truth(value(args(line)[0], state));
            branches.push({parent, active: selected, taken: selected});
        } else if (name === 'Else If') {
            const branch = branches.at(-1);
            branch.active = branch.parent && !branch.taken && truth(value(args(line)[0], state));
            branch.taken ||= branch.active;
        } else if (!active() && /^(While|For Player Variable|For Global Variable)\(/.test(line)) {
            pc = blockEnd(pc);
        } else if (active()) {
            if (line === 'Abort;') return;
            if (line === 'Break;') {
                const index = branches.findLastIndex(branch => ['for', 'while'].includes(branch.kind));
                assert(index >= 0); pc = blockEnd(branches[index].start); branches.length = index;
                continue;
            }
            if (line === 'Abort If Condition Is False;') {
                if (!applies(rule, state)) return;
                continue;
            }
            if (line === 'Loop;' || line === 'Loop If Condition Is True;') {
                if (line === 'Loop;' || applies(rule, state)) {pc = -1; branches = [];}
                continue;
            }
            const a = args(line), v = i => value(a[i], state);
            switch (name) {
                case 'While':
                    if (!truth(v(0))) pc = blockEnd(pc);
                    else branches.push({kind: 'while', active: true, start: pc, predicate: a[0]});
                    break;
                case 'For Global Variable':
                    state.globals[a[0]] = Number(v(1));
                    if (state.globals[a[0]] >= Number(v(2))) pc = blockEnd(pc);
                    else branches.push({kind: 'for', global: true, active: true, field: a[0],
                        limit: Number(v(2)), step: Number(v(3)), start: pc});
                    break;
                case 'For Player Variable': {
                    assert.equal(a[0], 'Event Player');
                    state.player[a[1]] = Number(v(2));
                    if (state.player[a[1]] >= Number(v(3))) {
                        pc = blockEnd(pc);
                    } else branches.push({kind: 'for', active: true, field: a[1],
                        limit: Number(v(3)), step: Number(v(4)), start: pc});
                    break;
                }
                case 'Loop If': if (truth(v(0))) {pc = -1; branches = [];} break;
                case 'Abort If': if (truth(v(0))) return; break;
                case 'Skip If': if (truth(v(0))) pc += Number(v(1)); break;
                case 'Skip': pc += Number(v(0)); break;
                case 'Set Player Variable': if (v(0)) v(0)[a[1]] = v(2); break;
                case 'Attach Players': v(0).attachedTo = v(1); v(0).attachmentOffset = v(2); break;
                case 'Detach Players': v(0).attachedTo = null; break;
                case 'Set Player Variable At Index': state.player[a[1]][Number(v(2))] = v(3); break;
                case 'Set Global Variable': state.globals[a[0]] = v(1); break;
                case 'Set Global Variable At Index': state.globals[a[0]][Number(v(1))] = v(2); break;
                case 'Modify Global Variable': {
                    const current = state.globals[a[0]] ?? 0, operand = v(2);
                    // Workshop vectors are scalar values, represented here as JS arrays.
                    if (a[1] === 'Append To Array') state.globals[a[0]] = array(current).concat(
                        a[0] === 'supplyPowerUpPositionList' && !a[2].startsWith('Mapped Array(') ? [operand] : operand);
                    else if (a[1] === 'Remove From Array By Index') state.globals[a[0]] = array(current).filter((_, index) => index !== Number(operand));
                    else throw new Error('Unsupported global modification: ' + line);
                    break;
                }
                case 'Destroy In-World Text': (state.destroyedTexts ??= []).push(v(0)); break;
                case 'Modify Player Variable': {
                    const current = state.player[a[1]] ?? 0;
                    state.player[a[1]] = a[2] === 'Append To Array' ? array(current).concat(v(3))
                        : a[2] === 'Multiply' ? Number(current) * Number(v(3))
                        : a[2] === 'Divide' ? Number(current) / Number(v(3))
                        : Number(current) + (a[2] === 'Add' ? 1 : -1) * Number(v(3));
                    break;
                }
                case 'Wait Until': yield {until: a[0], deadline: state.time + Number(v(1))}; break;
                case 'Wait':
                    // Workshop clamps Wait(0) to one frame; OverPy emits it for wait(0.016).
                    yield {deadline: state.time + Math.max(0.016, Number(v(0))), abort: a[1] === 'Abort When False'};
                    if (a[1] === 'Abort When False' && !applies(rule, state)) return;
                    break;
                case 'Set Max Ammo': {
                    const clip = Number(v(1)), amount = v(2);
                    state.ammoWrites.push({action: 'max', clip, amount});
                    const ignored = state.ignoreMaxAmmoWrites === true || Array.isArray(state.ignoreMaxAmmoWrites) && state.ignoreMaxAmmoWrites.includes(clip);
                    if (!ignored) {
                        state.maxAmmo[clip] = amount;
                        state.capacityBindings[clip] = {clip, amount, clipExpr: a[1], amountExpr: a[2],
                            clipCaptured: a[1].startsWith('Evaluate Once('), amountCaptured: a[2].startsWith('Evaluate Once(')};
                    }
                    break;
                }
                case 'Set Ammo':
                    state.ammoWrites.push({action: 'current', clip: Number(v(1)), amount: v(2)});
                    // Set Ammo can overfill a clip even when Set Max Ammo failed.
                    // Keeping these independent reproduces the reported 60/30 case.
                    state.ammo[Number(v(1))] = v(2); break;
                case 'Apply Impulse': {
                    const target = v(0), direction = v(1), speed = v(2), length = magnitude(direction);
                    state.impulses.push({direction, speed, relative: a[3], ...(target === state.player ? {} : {target: target.id})});
                    if (a[4] === 'Incorporate Contrary Motion') {
                        const velocity = target === state.player ? state.velocity : target.velocity ?? [0, 0, 0];
                        const updated = velocity.map((x, i) => x + (length ? direction[i] / length * speed : 0));
                        if (target === state.player) state.velocity = updated;
                        else target.velocity = updated;
                    }
                    break;
                }
                case 'Set Environment Credit Player':
                    v(0).environmentCreditor = v(1);
                    state.environmentCredits.push(v(0).id);
                    break;
                case 'Create Beam Effect': {
                    const id = ++state.lastEntity;
                    state.beams.push({id, type: a[1], from: a[2], to: a[3], color: a[4], reevaluation: a[5]});
                    state.liveEffects.add(id);
                    break;
                }
                case 'Destroy Effect': state.destroyedEffects.push(v(0)); state.liveEffects.delete(v(0)); break;
                case 'Set Status': {
                    const target = v(0);
                    if (target === state.player) state.status.add(a[2]);
                    else (target.status ??= new Set()).add(a[2]);
                    state.statusWrites.push({status: a[2], duration: v(3), ...(target === state.player ? {} : {target: target.id})});
                    break;
                }
                case 'Disable Movement Collision With Players': case 'Enable Movement Collision With Players':
                    assert.equal(v(0), state.player);
                    state.playerCollisionEnabled = name === 'Enable Movement Collision With Players';
                    state.collisionWrites.push({enabled: state.playerCollisionEnabled, time: state.time});
                    break;
                case 'Call Subroutine': yield* execute(compiled.get(a[0]), state, compiled); break;
                case 'Damage': {
                    const target = v(0);
                    if (state.expectedDamager !== undefined) assert.equal(v(1), state.expectedDamager);
                    assert(!Array.isArray(target), 'Each scripted augment Damage must target one player for actual-hit checks');
                    const targets = Array.isArray(target) ? target : [target];
                    state.damage.push({targets, amount: v(2), time: state.time});
                    for (const recipient of targets) {
                        if (!recipient.invincible) recipient.health = Math.max(0, (recipient.health ?? 10000) - v(2) * (recipient.damageMultiplier ?? 1));
                    }
                    break;
                }
                case 'Play Effect':
                    assert(['All Players(All Teams)', 'All Players(Team 1)', 'Event Player'].includes(a[0]));
                    state.effects.push({effect: a[1], color: a[2], position: v(3), size: v(4)});
                    break;
                case 'Create In-World Text': break;
                case 'Create HUD Text': state.huds++; break;
                case 'Start Heal Over Time': state.healOverTime = [v(2), v(3)]; break;
                case 'Chase Player Variable At Rate':
                    assert.equal(a[1], 'infectionLevel');
                    (state.chases ??= []).push({field: a[1], destination: v(2), rate: v(3)});
                    break;
                case 'Teleport': state.player.position = v(1); break;
                case 'Set Move Speed': state.moveSpeed = v(1); break;
                case 'Stop All Damage Over Time': state.stoppedDots = true; break;
                case 'Clear Status': state.status.delete(a[1]); break;
                case 'Set Ultimate Charge': state.ultCharge = Math.min(100, v(1)); break;
                case 'Heal':
                    assert.equal(v(1), state.expectedHealer ?? 0, 'Unexpected healer attribution');
                    state.healBonus = v(2);
                    state.player.health = Math.min(state.maxHealth, state.player.health + v(2));
                    break;
                case 'Small Message': state.messages.push(v(1)); break;
                case 'Add Health Pool To Player':
                    (state.healthPools ??= []).push({type: a[1], amount: v(2), recoverable: v(3), reevaluate: v(4)});
                    if (a[1] === 'Armor') state.armor += v(2);
                    break;
                default: throw new Error('Unsupported action: ' + line);
            }
        }
    }
}

function start(rule, state, compiled) {
    assert(applies(rule, state), 'Rule cannot start: ' + rule.name);
    const iterator = execute(rule, state, compiled);
    let pending = iterator.next(), iterations = 0;
    const resume = () => {
        while (!pending.done && (pending.value.until && truth(value(pending.value.until, state))
            || state.time >= pending.value.deadline || pending.value.abort && !applies(rule, state))) {
            assert(++iterations < 1000, 'Unexpected busy loop');
            pending = iterator.next();
        }
    };
    resume();
    return {resume, done: () => pending.done, deadline: () => pending.value?.deadline};
}

function scenario(augmentId, overrides = {}) {
    return {time: 100, player: {augmentId, sizeScale: 1, movementSpeedScale: 1, position: [0, 0, 0]},
        globals: {isGameplayActive: true, isPregameSetup: false}, alive: true, spawned: true,
        dummy: false, ground: false, buttons: new Set(overrides.firing ? ['Primary Fire'] : []), throttle: [0, 0, 1], facing: [0, 0, 1], yaw: 0,
        hero: 'Soldier: 76', weapon: 1, ammo: [18, 4], maxAmmo: [20, 10],
        meleeing: false, firing: false, blocking: false, ultimate: false, ability: false, reloading: false, alternateForm: false,
        status: new Set(), statusWrites: [], impulses: [], targets: [], damage: [], effects: [], armor: 0, huds: 0,
        playerCollisionEnabled: true, collisionWrites: [], maxArmor: 100,
        velocity: [0, 0, 0], lineOfSight: true, lastEntity: 0, beams: [], liveEffects: new Set(), destroyedEffects: [],
        environmentCredits: [],
        ammoWrites: [], messages: [], capacityBindings: {}, randomCalls: [],
        ...overrides};
}

async function main() {
    await compiler.readyPromise;
    const build = await compile(files);
    assert.deepEqual(build.warnings, []);
    const parsed = rules(build.result), compiled = new Map(parsed.map(rule => [rule.name, rule]));
    const run = (name, state) => start(compiled.get(name), state, compiled);
    // Run the shared pickup handler across both normal cure and timeout paths.
    const pickup = 'PLAYER PICKS UP HEALTH PACK';
    let pickupCases = 0;
    for (const augment of [1, 8]) for (const enhancement of [1, 2]) for (const difficulty of [1, 3, 5])
    for (const remaining of [30, 0, -30]) for (const infection of [-2, 0, 0.5, 1, 4])
    for (const healing of [10, 75, 250]) for (const charge of [0, 94.75, 95, 95.25, 98, 100]) {
        const state = scenario(augment, {eventWasHealthPack: true, eventHealing: healing,
            matchTime: remaining, ultCharge: charge, maxHealth: 1000});
        Object.assign(state.globals, {difficultySetting: difficulty, matchEndTime: 0,
            healthpackPositionList: [[0, 0, 0]]});
        Object.assign(state.player, {enhancementId: enhancement, infectionLevel: infection, isInfected: infection >= 1, health: 500});
        state.status.add('Burning');
        run(pickup, state);
        const fullCure = difficulty < 3 || remaining > 0;
        const cured = fullCure && infection > 0 ? 0 : infection;
        assert.equal(state.player.infectionLevel,
            augment === 8 && enhancement !== 2 && cured > 0 ? Math.max(0, cured - 1) : cured);
        assert.equal(state.player.health, 500 + (augment === 8 ? healing : 0));
        assert.equal(state.ultCharge, augment === 8 ? Math.min(100, charge + 5) : charge);
        assert.equal(state.player.movementSpeedScale, 1);
        assert.deepEqual(state.healOverTime, [5, 20], 'Preserve existing pack regeneration');
        assert.equal(!!state.stoppedDots, fullCure);
        assert.equal(state.status.has('Burning'), !fullCure);
        assert.equal(state.messages.length, !fullCure && infection >= 1 && augment !== 8 ? 1 : 0);
        state.eventWasHealthPack = false;
        assert(!applies(compiled.get(pickup), state), 'Supplemental and other healing cannot trigger pickup bonuses');
        pickupCases++;
    }
    const capacitorEnergy = slot('enhancementCapacitorEnergy');
    const packChargeSlot = slot('enhancementCapacitorCharge');
    const packDeadlineSlot = slot('enhancementCapacitorDeadline');
    let packChargeCases = 0;
    for (const augment of [1, 8]) for (const enhancement of [1, 9])
    for (const healing of [0, 2.25, 75, 250]) for (const gameplay of [false, true])
    for (const attribution of ['none', 'self', 'other']) for (const healerFirst of [false, true]) {
        const state = scenario(augment, {eventWasHealthPack: true, eventHealing: healing,
            matchTime: -1, ultCharge: 0, maxHealth: 1000});
        Object.assign(state.globals, {difficultySetting: 3, matchEndTime: 0, isGameplayActive: gameplay});
        Object.assign(state.player, {enhancementId: enhancement, health: 500,
            [capacitorEnergy]: 10, [packChargeSlot]: 60, [packDeadlineSlot]: 101});
        const otherHealer = {id: 'other healer', [capacitorEnergy]: 123};
        state.healer = attribution === 'self' ? state.player : attribution === 'other' ? otherHealer : 0;
        const dealt = compiled.get('OVERCHARGE STORES HEALING');
        const selfHealingEvent = () => {
            if (attribution === 'self' && applies(dealt, state)) run(dealt.name, state);
        };
        if (healerFirst) selfHealingEvent();
        // Dealt-healing credit has no gameplay gate; only received-pack credit does.
        const expectedBeforePickup = 10 + (healerFirst && attribution === 'self' && enhancement === 9 ? healing / 3 : 0);
        run(pickup, state);
        const pickupCredit = gameplay && enhancement === 9 && attribution !== 'self' ? healing / 3 : 0;
        assert.equal(state.player[capacitorEnergy], expectedBeforePickup + pickupCredit,
            'Received packs credit only the selected Overcharge player; self attribution is handled by dealt healing');
        if (!healerFirst) selfHealingEvent();
        assert.equal(state.player[capacitorEnergy], 10 + (enhancement === 9 && (gameplay || attribution === 'self') ? healing / 3 : 0),
            JSON.stringify({augment, enhancement, healing, gameplay, attribution, healerFirst}));
        assert.equal(otherHealer[capacitorEnergy], 123, 'Receiver handling cannot write the healer state');
        assert.equal(state.player[packChargeSlot], 60, 'Pack energy cannot alter an armed burst');
        assert.equal(state.player[packDeadlineSlot], 101, 'Pack energy cannot refresh the burst window');
        assert.equal(state.player.health, 500 + (augment === 8 ? healing : 0), 'Apothecary supplemental healing is preserved');
        state.eventWasHealthPack = false;
        assert(!applies(compiled.get(pickup), state), 'Supplemental healing cannot reenter health-pack handling');
        packChargeCases++;
    }
    const returnPosition = slot('augmentApothecaryPosition');
    const teleportReady = slot('augmentApothecaryReady');
    assert.notEqual(returnPosition, teleportReady);
    assert(!compiled.has('APOTHECARY SPEED BONUS EXPIRES'));
    const rechargeTeleport = compiled.get('APOTHECARY ULTIMATE RECHARGE');
    const teleportRule = compiled.get('APOTHECARY TELEPORT');
    for (const destination of [[0, 0, 0], [12, 4, -9]]) {
        const state = scenario(8, {eventWasHealthPack: true, eventHealing: 75,
            matchTime: -1, ultCharge: 0, maxHealth: 1000});
        state.player.position = destination;
        state.player.movementSpeedScale = 1.25;
        run(pickup, state);
        assert.deepEqual(state.player[returnPosition], destination);
        assert.equal(state.player.movementSpeedScale, 1.25);
        state.player.position = [20, 2, 8];
        assert(!applies(rechargeTeleport, state));
        state.ultimate = true;
        run(rechargeTeleport.name, state);
        run(rechargeTeleport.name, state);
        assert.equal(state.player[teleportReady], true, 'Ultimate charge does not stack');
        state.buttons = new Set(['Crouch', 'Interact']);
        const task = run(teleportRule.name, state);
        assert(!task.done());
        state.time += 0.99;
        task.resume();
        assert.deepEqual(state.player.position, [20, 2, 8]);
        state.time += 0.01;
        task.resume();
        assert.deepEqual(state.player.position, destination);
        assert.equal(truth(state.player[teleportReady]), false);
        assert(!applies(teleportRule, state));
        assert.deepEqual(state.effects.at(-1), {effect: 'Bad Explosion', color: 'Color(Aqua)', position: [20, 2, 8], size: 4.5});
    }
    for (const interrupt of ['Crouch', 'Interact', 'death', 'game end']) {
        const state = scenario(8, {buttons: new Set(['Crouch', 'Interact'])});
        state.player[returnPosition] = [10, 0, 0];
        state.player[teleportReady] = true;
        const task = run(teleportRule.name, state);
        if (interrupt === 'death') state.alive = false;
        else if (interrupt === 'game end') state.globals.isGameplayActive = false;
        else state.buttons.delete(interrupt);
        task.resume();
        assert.equal(state.player[teleportReady], true, 'Interrupted hold preserves the charge');
        assert.equal(state.effects.length, 0);
    }
    for (const augment of [1, 8]) for (const crouch of [false, true]) {
        const state = scenario(augment, {buttons: new Set(['Interact', ...(crouch ? ['Crouch'] : [])])});
        assert.equal(applies(compiled.get('PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)'), state), augment !== 8 || !crouch);
    }
    {
        const state = scenario(8, {buttons: new Set(['Crouch', 'Interact'])});
        state.player[teleportReady] = true;
        assert(!applies(teleportRule, state), 'No teleport before a pack pickup');
        state.player[returnPosition] = [10, 0, 0];
        state.player.enhancementId = 11;
        state.player[slot('enhancementHeldZombie')] = {id: 'carried'};
        assert(!applies(teleportRule, state), 'Do not teleport with a carried Dead Weight zombie');
        assert(applies(compiled.get('PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)'), state), 'The carried zombie can still be thrown');
    }
    if (process.argv.includes('--apothecary-only')) {
        const hud = actions(compiled.get('PLAYER ENHANCEMENT AND AUGMENT INITIALIZATION')).find(line => line.startsWith('Create HUD Text(') && line.includes('augmentState1'));
        assert(hud && hud.includes('If-Then-Else((Event Player).augmentState1, Custom String("Hold [{0}] + [{1}] | {2}"'), 'The complete Apothecary button hint is conditional on its charge');
        const emitted = teleportRule.body;
        assert(emitted.includes('Wait(True, Abort When False)')); // OverPy emits numeric 1 as True.
        assert(emitted.includes('(Event Player).augmentState0 != Null'), 'Position must not compile to a truthiness check');
        if (process.argv.includes('--export')) {
            const exported = await compiler.compile(fs.readFileSync(path.join(root, 'main.opy'), 'utf8'),
                'en-US', root.replace(/\\/g, '/') + '/', 'main.opy');
            assert.deepEqual(exported.encounteredWarnings, []);
            assert.equal(exported.nbElements, build.elements);
            assert.deepEqual(rules(exported.result), parsed);
            fs.writeFileSync(path.join(root, 'main.ws.txt'), exported.result);
        }
        console.log(JSON.stringify({elements: build.elements, warnings: build.warnings, pickupCases, packChargeCases,
            checked: 'pack healing/infection/ult preserved; Zombie Hybrid excluded from Apothecary cure; speed removed; pickup position including origin; nonstacking charge; 1s hold; interrupted hold preserves charge; departure flash; Interact exclusion; Dead Weight guard; HUD; emitted null comparison',
            exported: process.argv.includes('--export')}, null, 2));
        return;
    }
    const dash = 'AUGMENT AIR ACTION INPUT', jump = dash, recharge = 'AUGMENT AIR ACTION RECHARGE';
    const ammo = 'AMMO PACK MAGAZINES', quick = 'LONG REACH QUICK MELEE', sword = 'LONG REACH VENDETTA SWORD';
    const readyAt = slot('augmentDashReadyAt'), jumpReady = slot('augmentIsAirActionReady');
    const jumpReadyAt = slot('augmentJumpReadyAt');
    assert.notEqual(jumpReady, jumpReadyAt, 'Landing/death must not overwrite the cooldown timestamp');
    const menu = 'PLAYER MENU CONTROLS (INTERACT, AUGMENT SELECTION)';
    for (const backwards of [false, true]) for (let id = 0; id <= 10; id++) {
        const state = scenario(id, {globals: {isPregameSetup: true}, buttons: new Set(['Interact', ...(backwards ? ['Secondary Fire'] : [])])});
        run(menu, state);
        assert.equal(state.player.augmentId, (id + (backwards ? 10 : 1)) % 11);
        state.globals.isPregameSetup = false;
        assert(!applies(compiled.get(menu), state));
    }
    let meleeOverchargeCases = 0;
    const runExtendedMelee = state => {
        // The helper reuses the native-radius entry for health; each caller
        // supplies a fresh query before a synchronous swing.
        Object.assign(state.globals, {tmp0: [2.5, 7.5, 30], tmp1: 40});
        run('extendAugmentMelee', state);
    };
    const meleeTargets = invincible => [4, 6].map((z, id) =>
        ({id, position: [0, 0, z], alive: true, visible: true, health: 1000, invincible}));
    for (const enhancement of [1, 9]) for (const charge of [0, 60, 100])
    for (const deadline of [0, 99, 100.3]) for (const invincible of [false, true])
    for (const time of [100, 100.3]) {
        const state = scenario(4, {targets: meleeTargets(invincible), time});
        Object.assign(state.player, {enhancementId: enhancement, [capacitorEnergy]: 500,
            [packChargeSlot]: charge, [packDeadlineSlot]: deadline});
        runExtendedMelee(state);
        const bonus = enhancement === 9 && charge > 0 && !invincible && (deadline === 0 || time < deadline);
        assert.deepEqual(state.damage.map(hit => hit.amount), bonus ? [40, charge, 40, charge] : [40, 40]);
        assert.equal(state.player[packDeadlineSlot], bonus && deadline === 0 ? time + 0.3 : deadline,
            'Only an actual first hit opens the burst; existing deadlines cannot be extended');
        assert.equal(state.player[packChargeSlot], charge, 'Extended hits preserve the fixed armed charge');
        assert.equal(state.player[capacitorEnergy], 500, 'Extended hits cannot spend the next energy bank');
        meleeOverchargeCases++;
    }
    const burstMelee = scenario(4, {targets: meleeTargets(false)});
    Object.assign(burstMelee.player, {enhancementId: 9, [capacitorEnergy]: 500,
        [packChargeSlot]: 75, [packDeadlineSlot]: 0});
    runExtendedMelee(burstMelee);
    assert.equal(burstMelee.player[packDeadlineSlot], 100.3);
    burstMelee.time = 100.15;
    burstMelee.player[capacitorEnergy] += 10;
    runExtendedMelee(burstMelee);
    assert.equal(burstMelee.player[packDeadlineSlot], 100.3, 'Later swings do not restart the window');
    assert.deepEqual(burstMelee.damage.map(hit => hit.amount), [40,75,40,75,40,75,40,75]);
    burstMelee.time = 100.3;
    runExtendedMelee(burstMelee);
    assert.deepEqual(burstMelee.damage.slice(-2).map(hit => hit.amount), [40,40], 'Expiry blocks bonus damage before cleanup runs');
    run('OVERCHARGE CLEARS CHARGE', burstMelee);
    assert.equal(burstMelee.player[packChargeSlot], 0);
    assert.equal(burstMelee.player[capacitorEnergy], 510);
    for (const targets of [[], meleeTargets(true),
        [{id: 'wall', position: [0,0,4], alive: true, visible: false, health: 1000},
         {id: 'too far', position: [0,0,9], alive: true, visible: true, health: 1000}]]) {
        const state = scenario(4, {targets});
        Object.assign(state.player, {enhancementId: 9, [packChargeSlot]: 75, [packDeadlineSlot]: 0});
        runExtendedMelee(state);
        assert.equal(state.player[packDeadlineSlot], 0, 'Misses, blocked and invulnerable targets preserve an unstarted burst');
    }
    const mixedMelee = scenario(4, {targets: meleeTargets(false)});
    mixedMelee.targets[0].invincible = true;
    Object.assign(mixedMelee.player, {enhancementId: 9, [packChargeSlot]: 75, [packDeadlineSlot]: 0});
    runExtendedMelee(mixedMelee);
    assert.deepEqual(mixedMelee.damage.map(hit => [hit.targets[0].id, hit.amount]), [[0,40],[1,40],[1,75]]);
    const syntheticBonus = scenario(4, {eventAbility: 0, eventDamage: 75, victim: {team: 2}});
    Object.assign(syntheticBonus.player, {enhancementId: 9, [packChargeSlot]: 75, [packDeadlineSlot]: 100.3});
    assert(!applies(compiled.get('OVERCHARGE BONUS DAMAGE'), syntheticBonus), 'Scripted melee/bonus damage cannot reenter native bonus handling');
    const prepareDash = (overrides = {}) => {
        // Start with takeoff still held and a different direction. Only movement
        // at the later, second Jump press may select the dash direction.
        const state = scenario(2, {...overrides, buttons: new Set(['Jump']), throttle: [0, 0, -1]});
        const airTask = run(recharge, state);
        assert(!applies(compiled.get(dash), state), 'The takeoff press must not activate Shock Landing');
        state.time = 100.1; state.buttons.clear(); airTask.resume();
        assert.equal(state.player[jumpReady], true);
        state.time = 100.2; state.throttle = overrides.throttle ?? [0, 0, 1];
        return {state, airTask};
    };
    const pressDash = state => {state.buttons.add('Jump'); return run(dash, state);};
    for (const blocked of [false, true]) for (const protectedAlready of [false, true]) {
        const {state} = prepareDash({status: new Set([...(blocked ? ['Rooted'] : []), ...(protectedAlready ? ['Invincible'] : [])])});
        const task = pressDash(state);
        assert.equal(state.impulses.length, blocked ? 0 : 1);
        assert.equal(state.statusWrites.length, blocked || protectedAlready ? 0 : 1);
        if (!blocked) {
            assert.equal(state.playerCollisionEnabled, false);
            if (!protectedAlready) assert.equal(state.statusWrites[0].duration, 0.5);
            state.time = 100.699; task.resume();
            assert.equal(state.playerCollisionEnabled, false, 'Collision stays disabled for the phase duration');
            state.time = task.deadline(); task.resume();
            assert.equal(state.playerCollisionEnabled, true);
            assert(task.done(), 'Collision cleanup must run despite the active cooldown');
            assert.deepEqual(state.collisionWrites.map(write => write.enabled), [false, true]);
            assert(Math.abs(state.collisionWrites[1].time - state.collisionWrites[0].time - 0.5) < 1e-9);
            assert.equal(state.player[readyAt], 113.2);
            state.time = 113.2;
            assert(!applies(compiled.get(dash), state), 'A completed dash cannot be repeated before landing');
        } else {
            assert.equal(state.collisionWrites.length, 0, 'A failed dash must not alter collisions');
            assert.equal(state.player[readyAt] ?? 0, 0, 'A failed dash must not spend the cooldown');
        }
    }
    const directions = [[0, 0, 1], [0, 0, -1], [1, 0, 0], [-1, 0, 0],
        [1, 0, 1], [1, 0, -1], [-1, 0, 1], [-1, 0, -1], [0, 0, 0],
        [0.2, 0, 0.8], [-0.8, 0, 0.2]];
    for (const direction of directions) {
        const {state} = prepareDash({throttle: direction}), task = pressDash(state);
        if (direction.some(x => x !== 0)) {
            assert.equal(state.impulses.length, 1);
            const pitch = 15 * Math.PI / 180;
            const horizontal = direction.map(Math.sign);
            const expected = [horizontal[0] / magnitude(horizontal) * Math.cos(pitch),
                Math.sin(pitch), horizontal[2] / magnitude(horizontal) * Math.cos(pitch)];
            assert(state.impulses[0].direction.every((x, i) => Math.abs(x - expected[i]) < 1e-9));
            assert.equal(state.impulses[0].speed, 25);
            assert.equal(state.impulses[0].relative, 'To World');
        } else assert.equal(state.impulses.length, 0, 'No directional input must not add a dash impulse');
        state.time = task.deadline(); task.resume();
        assert.equal(state.playerCollisionEnabled, true);
    }
    const {state: lookingUp} = prepareDash({yaw: 90, facing: [0, 1, 0]});
    pressDash(lookingUp);
    assert(Math.abs(lookingUp.impulses[0].direction[0] - Math.cos(15 * Math.PI / 180)) < 1e-9);
    assert(Math.abs(lookingUp.impulses[0].direction[1] - Math.sin(15 * Math.PI / 180)) < 1e-9,
        'Dash keeps a fixed 15-degree upward pitch independently of the camera');
    const waveZombie = (id, position, overrides = {}) => ({id, position, team: 2, alive: true, visible: true,
        [slot('botKnockbackScale')]: 1, ...overrides});
    const landingWave = 'PHASE DASH LANDING WAVE', pendingWave = slot('augmentDashHero');
    const {state: wave} = prepareDash(), waveTask = pressDash(wave);
    assert.equal(wave.impulses.length, 1, 'Landing wave must not fire on launch');
    wave.player.position = [10, 0, 0];
    wave.targets = [waveZombie('front', [25.9, 0, 0]), waveZombie('back', [14.1, 0, 0]),
        waveZombie('left', [20, 0, -6]), waveZombie('right', [20, 0, 5.9]),
        waveZombie('resistant', [22, 0, 0], {[slot('botKnockbackScale')]: 0.5}),
        waveZombie('launch position', [0, 0, 2]), waveZombie('outside', [26.01, 0, 0]),
        waveZombie('wall', [21, 0, 0], {visible: false}), waveZombie('dead', [21, 0, 1], {alive: false}),
        waveZombie('teleporting', [21, 0, 2], {[slot('botIsTeleporting')]: true}),
        waveZombie('attached', [21, 0, 3], {[slot('botIsAttached')]: true}),
        waveZombie('immune', [21, 0, 4], {[slot('botKnockbackScale')]: 0}),
        waveZombie('friendly', [21, 0, 0], {team: 1})];
    wave.time = waveTask.deadline() - 0.001; waveTask.resume();
    assert(!applies(compiled.get(landingWave), wave), 'No wave while still airborne');
    wave.time = waveTask.deadline(); waveTask.resume();
    assert.equal(wave.playerCollisionEnabled, true);
    assert.equal(wave.impulses.length, 1, 'Phase end must not emit a midair wave');
    wave.time = 120;
    assert(!applies(compiled.get(landingWave), wave), 'A long flight retains the pending landing wave');
    wave.player.position = [20, 0, 0]; wave.ground = true; run(landingWave, wave);
    assert.deepEqual(wave.impulses.slice(1).map(hit => hit.target), ['front', 'back', 'left', 'right', 'resistant'],
        'Push every eligible zombie around the landing position, including behind the player');
    assert.deepEqual(wave.environmentCredits, ['front', 'back', 'left', 'right', 'resistant']);
    for (const hit of wave.impulses.slice(1)) {
        const target = wave.targets.find(target => target.id === hit.target);
        const resistance = hit.target === 'resistant' ? 0.5 : 1;
        assert.equal(hit.speed, 32 * resistance);
        const horizontal = Math.hypot(hit.direction[0], hit.direction[2]) * hit.speed;
        const vertical = hit.direction[1] * hit.speed;
        assert(Math.abs(horizontal - 32 * Math.cos(6.5 * Math.PI / 180) * resistance) < 1e-9,
            'Landing wave retains strong horizontal push');
        assert(Math.abs(vertical - 32 * Math.sin(6.5 * Math.PI / 180) * resistance) < 1e-9,
            'Landing wave uses half the previous upward angle');
        assert(hit.direction[0] * (target.position[0] - 20) + hit.direction[2] * target.position[2] > 0,
            'Wave pushes away from the landing position rather than the phase endpoint/camera');
    }
    assert.equal(wave.playerCollisionEnabled, true);
    assert.equal(wave.damage.length, 7, 'The wave damages each target exactly once');
    assert(wave.damage.every(hit => hit.amount === 40));
    assert.deepEqual(wave.damage.flatMap(hit => hit.targets.map(target => target.id)),
        ['front', 'back', 'left', 'right', 'resistant', 'attached', 'immune'],
        'Every zombie in the wave takes damage, including zombies that cannot be pushed');
    assert(wave.damage.every(hit => hit.targets[0].health === 9960));
    assert.equal(wave.player[pendingWave], 0); assert.equal(wave.player[readyAt], 113.2);
    wave.ground = false; assert(!applies(compiled.get(landingWave), wave));
    wave.ground = true; assert(!applies(compiled.get(landingWave), wave), 'Later landings cannot emit another wave');
    const {state: stationary} = prepareDash({throttle: [0, 0, 0], velocity: [3, -2, 4]});
    const stationaryTask = pressDash(stationary);
    assert.equal(stationary.impulses.length, 0, 'Stationary activation does not add upward or directional movement');
    assert.deepEqual(stationary.velocity, [3, -2, 4], 'Stationary activation preserves existing movement');
    assert.equal(stationary.player[readyAt], 113.2);
    assert.equal(stationary.playerCollisionEnabled, false);
    assert.equal(stationary.statusWrites[0].duration, 0.5);
    stationary.time = stationaryTask.deadline(); stationaryTask.resume();
    assert.equal(stationary.playerCollisionEnabled, true);
    assert(!applies(compiled.get(landingWave), stationary));
    stationary.ground = true; stationary.targets = [waveZombie('stationary landing', [2, 0, 0])];
    run(landingWave, stationary);
    assert.deepEqual(stationary.impulses.map(hit => hit.target), ['stationary landing']);
    assert.deepEqual(stationary.environmentCredits, ['stationary landing']);
    assert.equal(stationary.damage.length, 1); assert.equal(stationary.damage[0].amount, 40);
    assert.deepEqual(stationary.damage[0].targets.map(target => target.id), ['stationary landing']);
    assert(!applies(compiled.get(landingWave), stationary), 'Stationary activation also produces only one wave');
    assert(build.result.includes('Shock Landing') && !build.result.includes('Phase Dash'), 'Menus and HUD use the new skill name');
    const {state: earlyLanding} = prepareDash(), earlyTask = pressDash(earlyLanding);
    earlyLanding.time = 100.3; earlyLanding.ground = true; earlyLanding.player.position = [40, 0, 0];
    earlyLanding.targets = [waveZombie('early landing', [41, 0, 0])]; run(landingWave, earlyLanding);
    assert.equal(earlyLanding.impulses.length, 2, 'Landing before phase end emits at that landing');
    assert.equal(earlyLanding.damage.length, 1); assert.equal(earlyLanding.damage[0].amount, 40);
    assert.equal(earlyLanding.playerCollisionEnabled, false, 'Early landing does not shorten collision protection');
    earlyLanding.time = earlyTask.deadline(); earlyTask.resume();
    assert.equal(earlyLanding.playerCollisionEnabled, true); assert.equal(earlyLanding.impulses.length, 2);
    assert.equal(earlyLanding.damage.length, 1, 'Phase end cannot repeat landing damage');
    const {state: lethalWave} = prepareDash(); pressDash(lethalWave); lethalWave.ground = true;
    lethalWave.targets = [waveZombie('lethal', [0, 0, 2], {health: 40}),
        waveZombie('invincible', [1, 0, 2], {health: 100, invincible: true})];
    run(landingWave, lethalWave);
    assert.equal(lethalWave.targets[0].health, 0); assert.equal(lethalWave.targets[1].health, 100);
    assert.deepEqual(lethalWave.environmentCredits, ['lethal', 'invincible']);
    assert.equal(lethalWave.damage.length, 2, 'Both targets receive one wave hit');
    for (const enhancement of [1, 3]) {
        const {state: pyroWave} = prepareDash({throttle: [0, 0, 0]});
        pyroWave.player.enhancementId = enhancement;
        pyroWave.player[slot('enhancementPyroHitList')] = [];
        pressDash(pyroWave); pyroWave.ground = true;
        pyroWave.targets = [waveZombie('front', [0, 0, 3]), waveZombie('back', [0, 0, -3]),
            waveZombie('attached', [1, 0, 2], {[slot('botIsAttached')]: true}),
            waveZombie('unpushable', [-1, 0, 2], {[slot('botKnockbackScale')]: 0}),
            waveZombie('invincible', [2, 0, 2], {invincible: true}),
            waveZombie('wall', [0, 0, 2], {visible: false}), waveZombie('dead', [0, 0, 2], {alive: false}),
            waveZombie('outside', [0, 0, 6.01]),
            waveZombie('teleporting', [0, 0, 2], {[slot('botIsTeleporting')]: true})];
        run(landingWave, pyroWave);
        assert.equal(pyroWave.damage.length, 5); assert(pyroWave.damage.every(hit => hit.amount === 40));
        const expected = enhancement === 3 ? ['front', 'back', 'attached', 'unpushable'] : [];
        assert.deepEqual(array(pyroWave.player[slot('enhancementPyroHitList')]).map(target => target.id), expected,
            'Only actual damaging hits with Pyrotechnic enter its burn queue, including unpushable zombies');
        const burns = pyroWave.statusWrites.filter(write => write.status === 'Burning');
        assert.deepEqual(burns.map(write => write.target), expected);
        assert(burns.every(write => write.duration === 3));
        assert(!applies(compiled.get(landingWave), pyroWave), 'A spent wave cannot add repeated burns');
    }
    const {state: scaledWave} = prepareDash();
    scaledWave.player.enhancementId = 3; scaledWave.player.sizeScale = 3;
    pressDash(scaledWave); scaledWave.ground = true;
    scaledWave.targets = [waveZombie('inside pyro range', [0, 0, 14.99]), waveZombie('at pyro limit', [0, 0, 15]),
        waveZombie('outside pyro range', [0, 0, 17])];
    run(landingWave, scaledWave);
    assert.equal(scaledWave.damage.length, 3);
    assert.deepEqual(array(scaledWave.player[slot('enhancementPyroHitList')]).map(target => target.id), ['inside pyro range'],
        'Scaled waves retain Pyrotechnic\'s strict 15-meter burn limit');
    for (const cancel of [s => {s.alive = false;}, s => {s.hero = 'Ana';}, s => {s.globals.isGameplayActive = false;}]) {
        const {state} = prepareDash(), task = pressDash(state);
        state.targets = [waveZombie('must not push', [0, 0, 2])]; cancel(state);
        run(landingWave, state);
        state.time = task.deadline(); task.resume();
        assert.equal(state.impulses.length, 1, 'Death / hero changes / game end suppress the wave');
        assert.equal(state.damage.length, 0, 'Cancelled waves deal no damage');
        assert.equal(state.playerCollisionEnabled, true, 'Cancelled waves still restore collisions');
        assert.equal(state.player[pendingWave], 0);
        state.alive = true; state.hero = 'Soldier: 76'; state.globals.isGameplayActive = true; state.ground = true;
        assert(!applies(compiled.get(landingWave), state), 'Cancelled waves cannot survive respawn or hero restoration');
    }
    for (const interrupt of [s => {s.alive = false;}, s => {s.hero = 'Ana';},
        s => {s.globals.isGameplayActive = false;}, s => {s.throttle = [0, 0, 0];}]) {
        const {state} = prepareDash(), task = pressDash(state);
        assert.equal(state.playerCollisionEnabled, false);
        interrupt(state); task.resume();
        state.time = task.deadline(); task.resume();
        assert.equal(state.playerCollisionEnabled, true, 'Interruptions must not leave collision disabled');
        assert(task.done());
    }
    const grounded = scenario(2, {ground: true, buttons: new Set(['Jump'])});
    assert(!applies(compiled.get(dash), grounded), 'Jump on the ground is never a dash');
    const heldJump = scenario(2, {buttons: new Set(['Jump'])}), heldFlight = run(recharge, heldJump);
    for (const throttle of [[0, 0, 1], [0, 0, 0], [0, 0, 1]]) {
        heldJump.throttle = throttle; heldJump.time += 0.1; heldFlight.resume();
        assert(!applies(compiled.get(dash), heldJump), 'Holding Jump or double-tapping movement must not dash');
    }
    heldJump.alive = false; heldFlight.resume();
    assert.equal(heldJump.player[jumpReady], 0);
    const {state: cooldownDash, airTask: firstDashFlight} = prepareDash();
    const firstDash = pressDash(cooldownDash);
    cooldownDash.time = firstDash.deadline(); firstDash.resume();
    cooldownDash.ground = true; firstDashFlight.resume();
    assert.equal(cooldownDash.player[readyAt], 113.2, 'Landing must preserve the dash cooldown');
    cooldownDash.ground = false; cooldownDash.buttons.clear();
    run(recharge, cooldownDash);
    cooldownDash.time = 113.199; pressDash(cooldownDash);
    assert.equal(cooldownDash.impulses.length, 1, 'A second flight cannot bypass the 13s cooldown');
    cooldownDash.time = 113.2; cooldownDash.buttons.clear();
    const secondDash = pressDash(cooldownDash);
    assert.equal(cooldownDash.impulses.length, 2);
    cooldownDash.time = secondDash.deadline(); secondDash.resume();
    cooldownDash.time = 126.2;
    assert(!applies(compiled.get(dash), cooldownDash), 'Expiry alone must not add another action in the same flight');
    const air = scenario(3, {buttons: new Set(['Jump'])}), jumpTask = run(recharge, air);
    assert(!applies(compiled.get(jump), air));
    air.buttons.clear(); jumpTask.resume(); assert.equal(air.player[jumpReady], true);
    air.buttons.add('Jump'); run(jump, air); assert.equal(air.impulses.length, 1);
    assert.equal(air.impulses[0].speed, 14.4);
    assert.equal(air.player[jumpReadyAt], 116);
    assert(!applies(compiled.get(jump), air));
    air.buttons.clear(); jumpTask.resume(); air.buttons.add('Jump');
    assert(!applies(compiled.get(jump), air), 'No third jump');
    air.ground = true; jumpTask.resume(); assert.equal(air.player[jumpReady], 0);
    assert.equal(air.player[jumpReadyAt], 116, 'Landing preserves the cooldown');
    air.ground = false; air.buttons.clear(); const secondFlight = run(recharge, air);
    assert.equal(air.player[jumpReady], true, 'Walking off a ledge also permits an extra jump');
    air.time = 115.999; air.buttons.add('Jump'); run(jump, air);
    assert.equal(air.impulses.length, 1, 'A new airborne interval cannot bypass the 16s cooldown');
    assert.equal(air.player[jumpReadyAt], 116, 'A failed press must not restart the cooldown');
    air.time = 116; air.buttons.clear(); air.buttons.add('Jump');
    air.status.add('Stunned'); air.buttons.add('Jump'); run(jump, air);
    assert.equal(air.impulses.length, 1, 'Cannot jump out of crowd control');
    air.status.clear(); air.buttons.clear(); air.buttons.add('Jump'); run(jump, air);
    assert.equal(air.impulses.length, 2, 'A fresh press works exactly when the cooldown expires');
    assert.equal(air.player[jumpReadyAt], 132);
    air.time = 132;
    assert(!applies(compiled.get(jump), air), 'Cooldown expiry must not grant a third jump before landing');
    air.alive = false; secondFlight.resume();
    assert.equal(air.player[jumpReadyAt], 132, 'Death preserves the cooldown timestamp');
    const dying = scenario(3), deathTask = run(recharge, dying);
    assert.equal(dying.player[jumpReady], true);
    dying.alive = false; deathTask.resume();
    assert.equal(dying.player[jumpReady], 0, 'Death clears airborne readiness');
    const tapRule = 'DOUBLE JUMP DOUBLE TAP', tapAt = slot('augmentJumpLastPressedAt');
    const dispatchJump = (state, order = [tapRule, jump]) => {
        for (const name of order) if (applies(compiled.get(name), state)) run(name, state);
    };
    for (const ability of [false, true]) {
        const state = scenario(3, {ground: true, ability, buttons: new Set(['Jump'])});
        dispatchJump(state); assert.equal(state.impulses.length, 0, 'First grounded tap is a normal native jump attempt');
        state.buttons.clear(); state.time += 0.2; state.buttons.add('Jump'); dispatchJump(state);
        assert.deepEqual(state.impulses, [{direction: [0, 1, 0], speed: 14.4, relative: 'To World'}],
            'A second tap launches even when a native ability leaves the player grounded');
        assert.equal(state.player[readyAt], 116.2);
        state.buttons.clear(); state.time += 0.1; state.buttons.add('Jump'); dispatchJump(state);
        state.buttons.clear(); state.time += 0.1; state.buttons.add('Jump'); dispatchJump(state);
        assert.equal(state.impulses.length, 1, 'Both input methods share the same 16-second cooldown');
    }
    for (const order of [[tapRule, jump], [jump, tapRule]]) {
        const state = scenario(3, {buttons: new Set(['Jump'])});
        state.player[jumpReady] = true; state.player[tapAt] = 99.8;
        dispatchJump(state, order);
        assert.equal(state.impulses.length, 1, 'Airborne and rapid-tap events must not both produce an impulse');
        assert.equal(state.player[readyAt], 116);
        state.time = 116.1;
        state.player[tapAt] = 116;
        dispatchJump(state, order);
        assert.equal(state.impulses.length, 1, 'Double-tapping must not add a third jump before landing');
    }
    for (const interrupt of [s => s.status.add('Rooted'), s => s.status.add('Stunned'), s => {s.player.isAttached = true;}]) {
        const state = scenario(3, {ground: true, ability: true, buttons: new Set(['Jump'])});
        state.player[tapAt] = 99.8; interrupt(state); dispatchJump(state);
        assert.equal(state.impulses.length, 0); assert.equal(state.player[readyAt] ?? 0, 0);
    }
    const slowTap = scenario(3, {ground: true, buttons: new Set(['Jump'])});
    slowTap.player[tapAt] = 99.699; dispatchJump(slowTap);
    assert.equal(slowTap.impulses.length, 0, 'Taps farther than 0.3 seconds apart do not launch from the ground');
    const resetTap = scenario(3, {ground: true, buttons: new Set(['Jump'])});
    resetTap.player[tapAt] = 99.8; resetTap.alive = false;
    run('DOUBLE JUMP RESET TAP ON DEATH', resetTap); resetTap.alive = true;
    dispatchJump(resetTap); assert.equal(resetTap.impulses.length, 0, 'A pending tap does not survive death');
    assert(conditions(compiled.get(tapRule)).every(condition => !condition.includes('Total Time Elapsed')),
        'Holding Jump through expiry cannot create another tap');
    const bonusSlot = slot('augmentJumpBonusState'), hitBonus = 'DOUBLE JUMP FIRST HIT BONUS';
    const updateBonus = state => {
        for (const name of ['DOUBLE JUMP BONUS ENTER FLIGHT', 'DOUBLE JUMP BONUS LANDING WINDOW', 'DOUBLE JUMP BONUS EXPIRES']) {
            if (applies(compiled.get(name), state)) run(name, state);
        }
    };
    const armedJump = (overrides = {}) => {
        const state = scenario(3, {buttons: new Set(['Jump']), ...overrides});
        state.player[jumpReady] = true;
        run(jump, state); updateBonus(state);
        return state;
    };
    for (const amount of [0, 1, 20, 29, 29.999]) {
        const state = armedJump({victim: {id: 'threshold', team: 2, alive: true, position: [0, 0, 5]}, eventDamage: amount});
        assert(!applies(compiled.get(hitBonus), state), 'Hits below 30 must preserve the bonus');
        assert(Array.isArray(state.player[bonusSlot]));
        state.eventDamage = 30;
        run(hitBonus, state);
        assert.deepEqual(state.damage.map(hit => hit.amount), [15], 'Exactly 30 qualifies after a smaller hit');
        assert.equal(state.player[bonusSlot], 0);
        assert(!applies(compiled.get(hitBonus), state), 'The 15 supplemental damage cannot retrigger the bonus');
    }
    for (const button of ['Primary Fire', 'Melee', 'Ability 1', 'Ultimate', 0]) {
        const target = {id: 'bonus target', position: [0, 0, 5], team: 2, alive: true};
        const state = armedJump({victim: target, eventDamage: 100, eventAbility: button});
        state.time += 2; updateBonus(state);
        assert(applies(compiled.get(hitBonus), state), 'Bonus remains available throughout the first flight');
        run(hitBonus, state);
        assert.deepEqual(state.damage.map(hit => hit.amount), [50], 'The first native/script hit gains half its event damage');
        assert.equal(state.player[bonusSlot], 0);
        assert(!applies(compiled.get(hitBonus), state), 'A second hit and supplemental damage cannot consume/recurse again');
        state.ground = true; updateBonus(state);
        assert.equal(state.player[bonusSlot], 0, 'Landing cannot rearm a spent first-hit bonus');
    }
    for (const delay of [0.499, 0.5]) {
        const state = armedJump({victim: {id: 'landing', team: 2, alive: true, position: [0, 0, 5]},
            eventDamage: 80, eventAbility: 'Primary Fire'});
        state.time = 102; state.ground = true; updateBonus(state);
        assert.equal(state.player[bonusSlot][0], -102.5);
        state.time = 102 + delay;
        assert.equal(applies(compiled.get(hitBonus), state), delay < 0.5);
        if (delay < 0.5) {run(hitBonus, state); assert.equal(state.damage[0].amount, 40);}
        else {updateBonus(state); assert.equal(state.player[bonusSlot], 0);}
    }
    const stepOff = armedJump(); stepOff.time = 102; stepOff.ground = true; updateBonus(stepOff);
    stepOff.time = 102.2; stepOff.ground = false; updateBonus(stepOff);
    assert.equal(stepOff.player[bonusSlot][0], -102.5, 'Walking off another ledge does not restart the original flight window');
    stepOff.time = 102.5; updateBonus(stepOff); assert.equal(stepOff.player[bonusSlot], 0);
    for (const self of [false, true]) {
        const state = armedJump({victim: {team: 2}, eventAbility: 'Primary Fire', eventDamage: self ? 100 : 0});
        if (self) state.victim = state.player;
        assert(!applies(compiled.get(hitBonus), state), 'Zero damage and self hits do not spend the bonus');
        assert(Array.isArray(state.player[bonusSlot]));
    }
    for (const cancel of [s => {s.alive = false;}, s => {s.hero = 'Ana';}, s => {s.globals.isGameplayActive = false;}]) {
        const state = armedJump(); cancel(state); updateBonus(state);
        assert.equal(state.player[bonusSlot], 0, 'Death / hero changes / game end expire the bonus');
    }
    const noLiftoff = scenario(3, {ground: true, ability: true, buttons: new Set(['Jump'])});
    noLiftoff.player[tapAt] = 99.8; dispatchJump(noLiftoff); updateBonus(noLiftoff);
    noLiftoff.time = 100.5; updateBonus(noLiftoff);
    assert.equal(noLiftoff.player[bonusSlot], 0, 'A prevented liftoff cannot leave a permanent damage bonus');
    const movementCard = actions(compiled.get('PLAYER AUGMENT INITIALIZATION'))
        .filter(line => line.startsWith('Create HUD Text(')).at(-1);
    const movementHud = args(args(args(args(movementCard)[2])[1])[1])[2];
    for (const augmentId of [2, 3, 6]) {
        const state = scenario(augmentId); state.player[slot('augmentMovementReadyAt')] = 110;
        assert.equal(value(movementHud, state), '10s');
        state.time = 110; assert.equal(value(movementHud, state), '✓');
    }
    const grapnel = 'GRAPNEL LAUNCHER', grappleTargetSlot = slot('augmentGrapnelTarget');
    const zombie = (id, position = [0, 0, 20], overrides = {}) =>
        ({id, position, alive: true, visible: true, team: 2, ground: true, sizeScale: 1, ...overrides});
    const grapnelState = (overrides = {}) => scenario(6, {buttons: new Set(['Crouch', 'Jump']),
        targets: [zombie('locked')], ...overrides});
    const advancePull = (state, task, integrate = true) => {
        assert(!task.done());
        const elapsed = task.deadline() - state.time;
        if (integrate) state.player.position = state.player.position.map((x, i) => x + state.velocity[i] * elapsed);
        state.time = task.deadline(); task.resume();
    };
    const finishPull = (state, task, integrate = true) => {
        for (let step = 0; !task.done() && step < 40; step++) {
            assert(magnitude(state.velocity) <= 40 + 1e-8, 'Pull corrects velocity instead of stacking impulses');
            advancePull(state, task, integrate);
        }
        assert(task.done(), 'A blocked/unreachable hook must terminate within its travel timeout');
        assert.equal(state.liveEffects.size, 0, 'Every finished pull destroys its cable');
        assert.equal(state.player[grappleTargetSlot], 0);
        assert.equal(state.player[slot('augmentGrapnelState')], 0);
    };
    for (const buttons of [new Set(), new Set(['Jump']), new Set(['Crouch'])]) {
        assert(!applies(compiled.get(grapnel), grapnelState({buttons})), 'Both input buttons are required');
    }
    const selection = grapnelState({targets: [zombie('farther', [0, 0, 20]), zombie('nearest', [0, 0, 10]),
        zombie('too close', [0, 0, 6.99]),
        zombie('behind wall', [0, 0, 9], {visible: false}), zombie('dead', [0, 0, 8.2], {alive: false}),
        zombie('teleporting', [0, 0, 8.4], {[slot('botIsTeleporting')]: true}), zombie('ally', [0, 0, 8], {team: 1}),
        zombie('off aim', [8, 0, 10]), zombie('out of range', [0, 0, 41])]});
    const selectionTask = run(grapnel, selection);
    assert.equal(selection.player[grappleTargetSlot].id, 'nearest', 'Lock the nearest visible living aimed zombie');
    finishPull(selection, selectionTask);
    assert.deepEqual(selection.damage.map(hit => hit.targets[0].id), ['nearest']);
    const pull = grapnelState(), pulling = run(grapnel, pull);
    assert.equal(pull.player[readyAt], 116);
    assert.equal(pull.damage.length, 0, 'Launching the cable does not deal damage');
    assert.deepEqual(pull.effects, [{effect: 'Debuff Impact Sound', color: 'Color(White)', position: [0, 0, 0], size: 25}],
        'One launch sound, with no impact before arrival');
    assert.deepEqual(pull.player.position, [0, 0, 0], 'Pull uses movement rather than teleporting');
    assert.equal(pull.beams.length, 1); assert.equal(pull.beams[0].type, 'Grapple Beam');
    assert.equal(pull.beams[0].color, 'Null', 'White is the compiler default, matching the sentry cable');
    assert.equal(pull.beams[0].reevaluation, 'Visible To Position and Radius');
    assert.deepEqual(value(pull.beams[0].from, pull), [0, 0.75, 0]);
    assert.deepEqual(value(pull.beams[0].to, pull), [0, 0.75, 20]);
    pull.buttons.clear(); pull.meleeing = true; pull.globals.tmp0 = [999, 999, 999];
    advancePull(pull, pulling);
    assert(!pulling.done(), 'Releasing activation input and using Quick Melee do not cancel a committed hook');
    assert(Math.abs(value(pull.beams[0].from, pull)[2] - 2) < 1e-9, 'The cable start follows the player');
    pull.targets[0].position = [0.5, 0, 20.5];
    assert.deepEqual(value(pull.beams[0].to, pull), [0.5, 0.75, 20.5], 'The cable end follows the locked zombie');
    pull.targets.unshift(zombie('new closer zombie', [0, 0, 8]));
    finishPull(pull, pulling);
    assert.equal(pull.damage.length, 1); assert.equal(pull.damage[0].amount, 35);
    assert.equal(pull.damage[0].targets[0].id, 'locked', 'Do not retarget after launch');
    assert.deepEqual(pull.statusWrites, [{status: 'Stunned', duration: 0.5, target: 'locked'}]);
    assert.deepEqual(pull.effects.slice(1), [{effect: 'Bad Explosion', color: 'Color(Orange)',
        position: [0.5, 1, 20.5], size: 0.4}], 'Arrival plays one enlarged Long Reach impact on the locked zombie');
    assert(magnitude(pull.velocity) < 1e-8, 'Arrival cancels the remaining pull velocity');
    assert(!pull.impulses.some(impulse => impulse.speed === 14.4 && equal(impulse.direction, [0, 1, 0])),
        'Releasing Jump before arrival must not bounce');
    assert.equal(pull.player[readyAt], 116, 'The sixteen-second cooldown starts on a successful launch');
    assert(conditions(compiled.get(grapnel)).every(condition => !condition.includes('Total Time Elapsed')),
        'Cooldown expiry alone must not auto-launch while the chord remains held');
    assert(!/Disallow Button|Start Forcing Throttle|Set Move Speed/.test(compiled.get(grapnel).body), 'Melee input remains available');
    for (const heldOnArrival of [false, true]) {
        const state = grapnelState({targets: [zombie('minimum range', [0, 0, 7])]}), task = run(grapnel, state);
        assert.equal(state.player[readyAt], 116, 'Exactly seven meters is within launch range');
        state.buttons.delete('Jump'); state.buttons.delete('Crouch'); advancePull(state, task);
        if (heldOnArrival) state.buttons.add('Jump');
        finishPull(state, task);
        const bounces = state.impulses.filter(impulse => impulse.speed === 14.4 && equal(impulse.direction, [0, 1, 0]));
        assert.equal(bounces.length, 0, 'Grapnel arrival must not add a jump, even if Jump is held');
        assert(magnitude(state.velocity) < 1e-8, 'Arrival ends by stopping the pull');
    }
    for (const overrides of [{targets: []}, {targets: [zombie('off aim', [20, 0, 20])]},
        {targets: [zombie('far', [0, 0, 41])]}, {targets: [zombie('too close', [0, 0, 6.99])]}, {lineOfSight: false}]) {
        const miss = grapnelState(overrides), task = run(grapnel, miss);
        assert(task.done()); assert.equal(miss.beams.length, 0); assert.equal(miss.player[readyAt] ?? 0, 0);
        assert.deepEqual(miss.effects, []); assert.deepEqual(miss.statusWrites, []);
    }
    for (const status of ['Rooted', 'Stunned', 'Asleep', 'Frozen', 'Knocked Down']) {
        const state = grapnelState({status: new Set([status])}), task = run(grapnel, state);
        assert(task.done()); assert.equal(state.beams.length, 0); assert.equal(state.player[readyAt] ?? 0, 0);
    }
    const cooling = grapnelState(); cooling.player[readyAt] = 110;
    assert(run(grapnel, cooling).done()); assert.equal(cooling.beams.length, 0);
    const blocked = grapnelState(), blockedTask = run(grapnel, blocked);
    finishPull(blocked, blockedTask, false);
    assert.equal(blocked.damage.length, 0); assert(blocked.time < 101.6); assert(magnitude(blocked.velocity) < 1e-8);
    assert.equal(blocked.effects.length, 1); assert.equal(blocked.statusWrites.length, 0);
    assert(!blocked.impulses.some(impulse => impulse.speed === 14.4 && equal(impulse.direction, [0, 1, 0])),
        'Holding Jump through a travel timeout cannot bounce without arrival');
    for (const cancel of [s => {s.targets[0].alive = false;}, s => {s.targets[0].team = 1;},
        s => {s.targets[0][slot('botIsTeleporting')] = true;}, s => {s.lineOfSight = false;},
        s => {s.alive = false;}, s => {s.spawned = false;}, s => {s.hero = 'Ana';},
        s => {s.globals.isGameplayActive = false;}, s => {s.player.isAttached = true;},
        ...['Rooted', 'Stunned', 'Asleep', 'Frozen', 'Knocked Down'].map(status => s => s.status.add(status))]) {
        const state = grapnelState(), task = run(grapnel, state);
        cancel(state); advancePull(state, task, false);
        assert(task.done()); assert.equal(state.liveEffects.size, 0); assert.equal(state.damage.length, 0);
        assert.equal(state.effects.length, 1, 'Interruptions must not produce an impact');
        assert.deepEqual(state.statusWrites, [], 'Interruptions must not stun the target');
        assert(!state.impulses.some(impulse => impulse.speed === 14.4 && equal(impulse.direction, [0, 1, 0])),
            'Cancelled hooks must not grant an arrival jump');
        assert.equal(state.player[readyAt], 116, 'Cancelling/death does not reset the cooldown');
    }
    const controlled = grapnelState(), controlledTask = run(grapnel, controlled);
    controlled.status.add('Knocked Down'); controlled.velocity = [5, 10, 0];
    advancePull(controlled, controlledTask, false);
    assert.deepEqual(controlled.velocity, [5, 10, 0], 'Cleanup preserves crowd-control knockback');
    const large = grapnelState({targets: [zombie('large', [0, 0, 10], {sizeScale: 3})]});
    const largePull = run(grapnel, large); finishPull(large, largePull);
    assert.equal(large.damage.length, 1, 'Body-sized contact distance also reaches large zombies');
    for (const groundAtLaunch of [false, true]) for (const groundAtArrival of [false, true])
    for (const invincible of [false, true]) for (const enhancement of [0, 3]) {
        const target = zombie('changing altitude', [0, 0, 20], {ground: groundAtLaunch, invincible});
        const state = grapnelState({targets: [target]});
        state.player.enhancementId = enhancement;
        const task = run(grapnel, state);
        advancePull(state, task);
        assert.deepEqual(state.statusWrites, [], 'Launch and travel do not control the target');
        target.ground = groundAtArrival;
        finishPull(state, task);
        assert.deepEqual(state.statusWrites.filter(write => ['Stunned', 'Knocked Down'].includes(write.status)),
            [{status: groundAtArrival ? 'Stunned' : 'Knocked Down', duration: groundAtArrival ? 0.5 : 3, target: target.id}],
            'Arrival reads the target ground state, even if it changed in flight; control also applies to invulnerable targets');
        assert.equal(state.damage.length, 1);
        assert.equal(state.damage[0].amount, 35);
        assert.equal(state.player[readyAt], 116);
        assert.equal(state.statusWrites.filter(write => write.status === 'Burning').length,
            enhancement === 3 && !invincible ? 1 : 0, 'Both control branches preserve actual-hit Pyrotechnic burns');
    }
    for (const enhancement of [0, 3]) for (const invincible of [false, true]) {
        const state = grapnelState({targets: [zombie('pyro hook', [0, 0, 20], {invincible})]});
        state.player.enhancementId = enhancement;
        const task = run(grapnel, state);
        assert.deepEqual(array(state.player[slot('enhancementPyroHitList')]), [], 'Hook launch does not ignite a distant target');
        finishPull(state, task);
        const expected = enhancement === 3 && !invincible ? ['pyro hook'] : [];
        assert.deepEqual(array(state.player[slot('enhancementPyroHitList')]).map(target => target.id), expected,
            'Grapnel queues exactly one Pyrotechnic burn only after an actual damaging impact');
        assert.deepEqual(state.statusWrites.filter(write => write.status === 'Burning').map(write => write.target), expected);
        assert(state.statusWrites.filter(write => write.status === 'Burning').every(write => write.duration === 3));
        assert.deepEqual(state.statusWrites.filter(write => write.status === 'Stunned'), [{status: 'Stunned', duration: 0.5, target: 'pyro hook'}]);
    }
    const pyroMiss = grapnelState(); pyroMiss.player.enhancementId = 3;
    finishPull(pyroMiss, run(grapnel, pyroMiss), false);
    assert.deepEqual(array(pyroMiss.player[slot('enhancementPyroHitList')]), [], 'An unreachable hook must not ignite its target');
    const distantImpact = grapnelState({targets: [zombie('huge', [0, 0, 20], {sizeScale: 50})]});
    distantImpact.player.enhancementId = 3;
    finishPull(distantImpact, run(grapnel, distantImpact));
    assert.deepEqual(array(distantImpact.player[slot('enhancementPyroHitList')]), [], 'Grapnel retains Pyrotechnic\'s native 15-meter burn limit');
    const leaving = grapnelState(); run(grapnel, leaving);
    // Execute the supplied project's departure-event pattern before releasing
    // the player's state. This checks the handler, not native event timing.
    leaving.liveEffects.add(99);
    run('GRAPNEL LAUNCHER DISCONNECT CLEANUP', leaving);
    assert.deepEqual([...leaving.liveEffects], [99], 'Departure cleanup destroys only the departing player\'s cable');
    assert.deepEqual(leaving.destroyedEffects, [leaving.player[slot('augmentGrapnelState')][1]]);
    for (const state of [grapnelState(), scenario(5), pull]) {
        assert(!applies(compiled.get('GRAPNEL LAUNCHER DISCONNECT CLEANUP'), state),
            'Departure cleanup requires Grapnel Launcher with an active cable');
    }
    assert(!files['variables.opy'].includes('globalvar augmentGrapnel'), 'Cable ownership needs no additional global state');
    if (process.argv.includes('--grapnel-only')) {
        if (process.argv.includes('--export')) {
            const exported = await compiler.compile(fs.readFileSync(path.join(root, 'main.opy'), 'utf8'),
                'en-US', root.replace(/\\/g, '/') + '/', 'main.opy');
            assert.deepEqual(exported.encounteredWarnings, []);
            assert.equal(exported.nbElements, build.elements);
            assert.deepEqual(rules(exported.result), parsed);
            fs.writeFileSync(path.join(root, 'main.ws.txt'), exported.result);
        }
        console.log(JSON.stringify({elements: build.elements, warnings: build.warnings,
            groundTransitionCases: 16,
            checked: ['target ground state sampled on arrival, independent of player/launch state',
                'grounded 0.5s stun / airborne 3s knockdown', '35 damage / immunity / Pyrotechnic',
                '7-40m selection / live cable / moving targets / 16s cooldown',
                'misses / timeout / crowd control / death / hero switch / disconnect cleanup'],
            exported: process.argv.includes('--export')}, null, 2));
        return;
    }
    const gun = scenario(5), gunTask = run(ammo, gun);
    const settleAmmo = (state, task) => {state.time = task.deadline(); task.resume();};
    assert.deepEqual(gun.maxAmmo, [40, 20]); assert.deepEqual(gun.ammo, [38, 14]);
    settleAmmo(gun, gunTask); assert.deepEqual(gun.messages, []);
    assert.equal(gun.player[slot('augmentAmmoLoadoutList')].length, 1, 'Nested cached rows');
    gun.alive = false; gunTask.resume(); gun.alive = true; gun.ammo = [40, 20];
    const respawnTask = run(ammo, gun); assert.deepEqual(gun.maxAmmo, [40, 20], 'No repeated doubling');
    settleAmmo(gun, respawnTask);
    gun.weapon = 2; gun.maxAmmo = [8, 0]; gun.ammo = [5, 0]; respawnTask.resume();
    assert.deepEqual(gun.maxAmmo, [16, 0]); assert.deepEqual(gun.ammo, [13, 0]);
    settleAmmo(gun, respawnTask);
    gun.weapon = 1; gun.maxAmmo = [40, 20]; gun.ammo = [15, 7]; respawnTask.resume();
    assert.deepEqual(gun.ammo, [15, 7], 'Switching weapons must not refill spent ammo');
    settleAmmo(gun, respawnTask);
    assert.equal(gun.player[slot('augmentAmmoLoadoutList')].length, 2);
    gun.hero = 'Ana'; gun.maxAmmo = [15, 0]; gun.ammo = [15, 0]; respawnTask.resume();
    assert.deepEqual(gun.maxAmmo, [30, 0]);
    settleAmmo(gun, respawnTask);
    gun.hero = 'Soldier: 76'; gun.maxAmmo = [20, 10]; gun.ammo = [20, 10]; respawnTask.resume();
    assert.deepEqual(gun.maxAmmo, [40, 20]);
    settleAmmo(gun, respawnTask);
    const soldier = scenario(5, {ammo: [25, 0], maxAmmo: [25, 0]});
    const soldierTask = run(ammo, soldier);
    assert.deepEqual(soldier.maxAmmo, [50, 0]); assert.deepEqual(soldier.ammo, [50, 0]);
    assert(soldier.ammoWrites.every(write => write.clip === 0 && write.amount > 0),
        'A single-magazine weapon must never receive writes to the unused second clip');
    settleAmmo(soldier, soldierTask); assert.deepEqual(soldier.messages, []);
    // Audit the lifetime of the emitted persistent capacity inputs: later global
    // scratch reuse must not change their values when the weapon reloads.
    // This deliberately reevaluates retained inputs; it is not a full game emulation.
    const reloadWithRetainedInputs = state => {
        for (const binding of Object.values(state.capacityBindings)) {
            const clip = binding.clipCaptured ? binding.clip : Number(value(binding.clipExpr, state));
            const amount = binding.amountCaptured ? binding.amount : value(binding.amountExpr, state);
            if (clip >= 0 && clip < state.maxAmmo.length) state.maxAmmo[clip] = amount;
        }
        state.ammo = [...state.maxAmmo];
    };
    const fullMagazine = scenario(5, {ammo: [30, 0], maxAmmo: [30, 0]});
    const fullMagazineTask = run(ammo, fullMagazine); settleAmmo(fullMagazine, fullMagazineTask);
    assert.deepEqual(fullMagazine.maxAmmo, [60, 0]);
    const initialWrites = fullMagazine.ammoWrites.length;
    for (const [clipScratch, capacityScratch] of [[2, 0], [1, 30], [0, 120]]) {
        fullMagazine.globals.tmp0 = clipScratch; fullMagazine.globals.tmp1 = capacityScratch;
        fullMagazine.ammo[0] = 5;
        reloadWithRetainedInputs(fullMagazine);
        assert.deepEqual(fullMagazine.maxAmmo, [60, 0], 'The maximum must stay doubled after reload');
        assert.deepEqual(fullMagazine.ammo, [60, 0]);
    }
    assert.equal(fullMagazine.ammoWrites.length, initialWrites, 'Reload persistence must not require scripted refills');
    // The former uncaptured expression is a counterexample under the same lifetime audit.
    const uncaptured = scenario(5, {ammo: [60, 0], maxAmmo: [30, 0]});
    uncaptured.capacityBindings[0] = {clip: 0, amount: 60, clipExpr: 'Global.tmp0', amountExpr: 'Global.tmp1'};
    uncaptured.globals.tmp0 = 2; uncaptured.globals.tmp1 = 0;
    reloadWithRetainedInputs(uncaptured);
    assert.equal(uncaptured.ammo[0], 30);
    const failedWrite = scenario(5, {ammo: [25, 0], maxAmmo: [25, 0], ignoreMaxAmmoWrites: true});
    const failedTask = run(ammo, failedWrite);
    settleAmmo(failedWrite, failedTask);
    assert.deepEqual(failedWrite.ammo, [50, 0], 'Current ammo alone must not prove the maximum was increased');
    assert.deepEqual(failedWrite.maxAmmo, [25, 0]);
    assert.deepEqual(failedWrite.messages, []);
    assert(Array.isArray(failedWrite.player[slot('augmentAmmoFallbackState')]));
    const writesAfterFailure = failedWrite.ammoWrites.length;
    failedWrite.time += 10; failedTask.resume();
    assert.equal(failedWrite.ammoWrites.length, writesAfterFailure, 'Unsupported setters must not cause a busy retry loop');
    assert.equal(failedWrite.messages.length, 0, 'A supported fallback must not warn on every reload');
    const noMagazine = scenario(5, {ammo: [0, 0], maxAmmo: [0, 0]});
    const noMagazineTask = run(ammo, noMagazine); settleAmmo(noMagazine, noMagazineTask);
    assert.deepEqual(noMagazine.ammoWrites, [], 'Do not write zero capacity to an unlimited/unreadable weapon');
    const fallbackRule = compiled.get('AMMO PACK REFILL FALLBACK');
    const switching = scenario(5, {hero: 'Widowmaker', ammo: [0, 0], maxAmmo: [35, 0], ignoreMaxAmmoWrites: true});
    switching.player[slot('augmentAmmoFallbackState')] = [true, false, false, 5, 0];
    const switchingTask = run(ammo, switching);
    assert.equal(switching.ammo[0], 35);
    assert(!applies(fallbackRule, switching), 'Clear the old loadout snapshot before the initialization wait');
    settleAmmo(switching, switchingTask);
    assert.equal(switching.ammo[0], 35, 'Initializing a partially spent loadout must not grant a second refill');
    let fallbackRuns = 0;
    const observeAmmo = state => {
        if (applies(fallbackRule, state)) {
            run(fallbackRule.name, state); fallbackRuns++;
            assert(!applies(fallbackRule, state), 'Snapshot update must settle the refill event without a busy loop');
        }
    };
    assert.equal(fullMagazine.player[slot('augmentAmmoFallbackState')], 0);
    fullMagazine.ammo[0] = 0; fullMagazine.reloading = true;
    assert(!applies(fallbackRule, fullMagazine), 'A native 60/60 weapon must never enter the fallback');
    const widow = scenario(5, {hero: 'Widowmaker', ammo: [35, 0], maxAmmo: [35, 0], ignoreMaxAmmoWrites: true});
    const widowTask = run(ammo, widow); settleAmmo(widow, widowTask);
    assert.deepEqual(widow.ammo, [70, 0]); assert.deepEqual(widow.maxAmmo, [35, 0]);
    const beforeShootingWrites = widow.ammoWrites.length, beforeShootingRuns = fallbackRuns;
    for (let remaining = 69; remaining >= 0; remaining--) {
        widow.ammo[0] = remaining; observeAmmo(widow);
        assert.equal(widow.ammo[0], remaining, 'Firing down through 35 must not grant infinite ammo');
    }
    assert.equal(widow.ammoWrites.length, beforeShootingWrites);
    assert.equal(fallbackRuns - beforeShootingRuns, 1, 'Only the native-full boundary is tracked, not every shot');
    for (let cycle = 0; cycle < 3; cycle++) {
        widow.ammo[0] = 5; observeAmmo(widow);
        widow.reloading = true; observeAmmo(widow);
        widow.ammo[0] = 35; observeAmmo(widow);
        assert.equal(widow.ammo[0], 70, 'Every completed full reload restores the doubled reserve');
        widow.reloading = false; observeAmmo(widow);
        assert.equal(widow.ammo[0], 70, 'Reload completion must not add the bonus twice');
        assert.deepEqual(widow.maxAmmo, [35, 0], 'The native denominator remains unchanged on an unsupported hero');
    }
    widow.ammo[0] = 7; observeAmmo(widow);
    const beforeCancel = widow.ammoWrites.length;
    widow.reloading = true; observeAmmo(widow);
    widow.reloading = false; observeAmmo(widow);
    assert.equal(widow.ammo[0], 7); assert.equal(widow.ammoWrites.length, beforeCancel, 'Cancelling a reload must not refill');
    widow.ammo[0] = 35; observeAmmo(widow);
    assert.equal(widow.ammo[0], 70, 'A full refill from the existing automatic-reload rule also receives the bonus');
    widow.ammo[0] = 6; observeAmmo(widow);
    widow.reloading = true; observeAmmo(widow);
    widow.reloading = false; widow.ammo[0] = 34; observeAmmo(widow);
    assert.equal(widow.ammo[0], 69, 'Preserve the shot fired on the same frame a Widow reload finishes');
    widow.reloading = true; observeAmmo(widow);
    widow.ammo[0] = 35; observeAmmo(widow); // No lower-bound crossing when reloading from overfill.
    widow.reloading = false; observeAmmo(widow);
    assert.equal(widow.ammo[0], 70, 'A reload from an overfilled clip still restores its full reserve');
    const partial = scenario(5, {hero: 'Ashe', ammo: [12, 0], maxAmmo: [12, 0], ignoreMaxAmmoWrites: true});
    const partialTask = run(ammo, partial); settleAmmo(partial, partialTask);
    partial.ammo[0] = 5; observeAmmo(partial);
    partial.reloading = true; observeAmmo(partial);
    partial.ammo[0] = 6; observeAmmo(partial); partial.reloading = false; observeAmmo(partial);
    assert.equal(partial.ammo[0], 6, 'A cancelled incremental reload must not grant the full-magazine bonus');
    partial.reloading = true; observeAmmo(partial); partial.ammo[0] = 12; observeAmmo(partial);
    assert.equal(partial.ammo[0], 24);
    const dual = scenario(5, {hero: 'Baptiste', ammo: [30, 8], maxAmmo: [30, 8], ignoreMaxAmmoWrites: [1]});
    const dualTask = run(ammo, dual); settleAmmo(dual, dualTask);
    assert.deepEqual(dual.maxAmmo, [60, 8]); assert.deepEqual(dual.ammo, [60, 16]);
    dual.ammo[1] = 3; observeAmmo(dual); dual.ammo[1] = 8; observeAmmo(dual);
    assert.deepEqual(dual.ammo, [60, 16], 'Refill only the affected clip of a dual-ammo weapon');
    widow.ammo[0] = 3; observeAmmo(widow); widow.ammo[0] = 35;
    for (const override of [{alive: false}, {spawned: false}, {hero: 'Ana'}, {weapon: 2}]) {
        const state = {...widow, ...override};
        assert(!applies(fallbackRule, state), 'Do not apply a stale/dead loadout refill');
    }
    for (const [name, base, hero, amount] of [[quick, 2.5, 'Soldier: 76', 40], [quick, 2.5, 'Zenyatta', 60], [quick, 2.5, 'Venture', 70], [quick, 2.5, 'D.Mon', 40], [sword, 4.3, 'Vendetta', 45]]) {
        const attackState = () => {
            const state = scenario(4, {hero, meleeing: name === quick, firing: name === sword});
            run('PLAYER AUGMENT INITIALIZATION', state);
            return state;
        };
        const state = attackState();
        const multiplier = 3;
        state.targets = [base - 0.1, base + 0.1, base * multiplier, base * multiplier + 0.1].map((distance, id) => ({id, position: [0, 0, distance], alive: true, visible: true}));
        state.targets.push({id: 'wall', position: [0, 0, base + 0.1], alive: true, visible: false},
            {id: 'behind', position: [0, 0, -base - 0.1], alive: true, visible: true},
            {id: 'dead', position: [0, 0, base + 0.1], alive: false, visible: true},
            {id: 'left', position: [-0.5, 0, base * 1.5], alive: true, visible: true},
            {id: 'right', position: [0.5, 0, base * 1.5], alive: true, visible: true},
            {id: 'nearest', position: [0, 0, base + 0.05], alive: true, visible: true});
        for (const target of state.targets) target[slot('botKnockbackScale')] = 1;
        const attack = run(name, state); assert.equal(state.damage.length, 0);
        state.time += 0.15; attack.resume();
        assert.deepEqual(state.damage.flatMap(hit => hit.targets.map(target => target.id)), [1, 2, 'left', 'right', 'nearest']);
        assert(state.damage.every(hit => hit.targets.length === 1 && hit.amount === amount));
        assert.deepEqual(state.effects, [{effect: 'Bad Explosion', color: 'Color(Orange)',
            position: [0, 1, base + 0.05], size: 0.4}], 'One enlarged turret impact at the nearest hit target');
        assert.deepEqual(state.impulses, [], 'Extended melee damage does not add scripted knockback');
        assert.deepEqual(state.environmentCredits, [], 'Extended melee damage does not rewrite environmental kill credit');
        const empty = attackState();
        const miss = run(name, empty); empty.time += 0.15; miss.resume();
        assert.equal(empty.damage.length, 0, 'No damage action when no targets qualify');
        assert.equal(empty.effects.length, 0, 'Misses must not create an impact at the map origin');
        const interrupted = attackState();
        const canceled = run(name, interrupted); interrupted.alive = false; canceled.resume();
        assert.equal(interrupted.damage.length, 0);
        const switched = attackState();
        const previousHeroAttack = run(name, switched);
        switched.hero = 'Ana'; switched.time += 0.15; previousHeroAttack.resume();
        assert.equal(switched.damage.length, 0, 'Hero switching cancels a pending hit');
    }
    for (const enhancement of [0, 3]) for (const invincible of [false, true]) {
        const state = scenario(4, {meleeing: true, targets: [
            {id: 'a', position: [0, 0, 5.5], alive: true, visible: true, invincible},
            {id: 'b', position: [0, 0, 7], alive: true, visible: true, invincible}
        ]});
        state.player.enhancementId = enhancement;
        const task = run(quick, state); state.time += 0.15; task.resume();
        const expected = enhancement === 3 && !invincible ? ['a', 'b'] : [];
        assert.deepEqual(array(state.player[slot('enhancementPyroHitList')]).map(target => target.id), expected,
            'Pyrotechnic queues each actual extended hit once, without igniting invulnerable targets');
        assert.deepEqual(state.statusWrites.map(write => write.target), expected);
        assert(state.statusWrites.every(write => write.status === 'Burning' && write.duration === 3));
    }
    const weapons = 'LONG REACH MELEE WEAPONS', carnage = 'LONG REACH CARNAGE';
    const weaponCases = [
        ['Reinhardt', 4, 100, 0.4, 0.96, {}],
        ['Brigitte', 6, 45, 0.2, 0.6, {}],
        ['D.Mon', 4, 60, 0.2, 0.656, {}],
        ['Genji', 5, 100, 0.15, 0.7 / 1.15, {ultimate: true}],
        ['Ramattra', 10, 65, 0.15, 0.6, {maxArmor: 375}],
        ['Torbjörn', 2.5, 70, 0.35, 0.7, {weapon: 2}]
    ];
    const weaponState = (hero, base, overrides) => {
        const state = scenario(4, {hero, firing: true,
            targets: [base - 0.1, base, base + 0.1, base * 3, base * 3 + 0.1].map((distance, id) =>
                ({id, position: [0, 0, distance], alive: true, visible: true})), ...overrides});
        state.player.initialMaxHealth = 525;
        state.player.enhancementId = 3;
        return state;
    };
    for (const [hero, base, amount, windup, interval, overrides] of weaponCases) {
        const state = weaponState(hero, base, overrides), task = run(weapons, state);
        assert.equal(state.damage.length, 0);
        for (let hit = 0; hit < 3; hit++) {
            if (hit) {state.time = task.deadline(); task.resume();}
            state.time = task.deadline(); task.resume();
            assert.deepEqual(state.damage.slice(hit * 2).flatMap(event => event.targets.map(target => target.id)), [2, 3],
                hero + ': hit every outer-zone target, excluding native reach and out-of-range targets');
            assert(state.damage.slice(hit * 2).every(event => event.amount === amount));
            assert(Math.abs(state.damage[hit * 2].time - (100 + windup + hit * interval)) < 1e-9,
                hero + ': held attacks repeat on their own cadence');
        }
        const expectedBurns = base * 3 < 15 ? [2, 3, 2, 3, 2, 3] : [2, 2, 2];
        assert.deepEqual(array(state.player[slot('enhancementPyroHitList')]).map(target => target.id), expectedBurns,
            hero + ': extended damage uses the existing Pyrotechnic distance limit');
        const tapped = weaponState(hero, base, overrides), tap = run(weapons, tapped);
        tapped.time += 0.02; tapped.buttons.clear(); tapped.firing = false; tap.resume();
        assert.equal(tapped.damage.length, 0);
        tapped.time = tap.deadline(); tap.resume();
        assert.equal(tapped.damage.length, 2, hero + ': a short click still commits a strike');
        tapped.time += 2; tap.resume(); assert.equal(tapped.damage.length, 2);
        for (const stop of [s => {s.alive = false;}, s => {s.blocking = true;}, s => s.status.add('Stunned'),
            s => {s.hero = 'Ana';}, s => {s.globals.isGameplayActive = false;}]) {
            const interrupted = weaponState(hero, base, overrides), swing = run(weapons, interrupted);
            stop(interrupted); interrupted.time += windup; swing.resume();
            assert.equal(interrupted.damage.length, 0, hero + ': interruptions cancel the windup');
        }
        const invalidForm = {
            'D.Mon': s => {s.alternateForm = true;},
            Genji: s => {s.ultimate = false;},
            Ramattra: s => {s.maxArmor = 100;},
            'Torbjörn': s => {s.weapon = 1;}
        }[hero];
        if (invalidForm) {
            const transformed = weaponState(hero, base, overrides), attack = run(weapons, transformed);
            invalidForm(transformed); transformed.time += windup; attack.resume();
            assert.equal(transformed.damage.length, 0, hero + ': leaving the melee form cancels a pending hit');
        }
    }
    for (const [hero, base, overrides] of weaponCases.filter(row => ['Reinhardt', 'Brigitte', 'Torbjörn'].includes(row[0])).map(row => [row[0], row[1], row[5]])) {
        const state = weaponState(hero, base, {...overrides, firing: false, meleeing: true, buttons: new Set(['Melee'])});
        assert(!applies(compiled.get(quick), state), 'Native melee weapons must not enter Quick Melee too');
        const swing = run(weapons, state); state.time = swing.deadline(); swing.resume();
        assert.equal(state.damage.length, 2, hero + ': the Melee binding also swings the equipped weapon');
    }
    for (const overrides of [{hero: 'Genji'}, {hero: 'Torbjörn', weapon: 1}, {hero: 'D.Mon', alternateForm: true},
        {hero: 'D.Mon', meleeing: true}, {hero: 'D.Mon', ability2: true},
        {hero: 'Ramattra', maxArmor: 100}, {hero: 'Ramattra', maxArmor: 375, meleeing: true}]) {
        const state = weaponState(overrides.hero, 4, overrides);
        assert(!applies(compiled.get(weapons), state), 'Only the actual melee weapon/form may start an extended swing');
    }
    for (const scale of [0.3, 1, 3]) {
        const state = weaponState('Ramattra', 10, {maxArmor: 375 * scale, ability1: true});
        state.player.initialMaxHealth = 525 * scale;
        assert(applies(compiled.get(weapons), state), 'Nemesis detection respects health scaling and ignores the unreliable ability flag');
        state.maxArmor = 100 * scale;
        assert(!applies(compiled.get(weapons), state), 'An Omnic staff must not create extended punches');
    }
    const idleSwitch = weaponState('Reinhardt', 4, {firing: false, buttons: new Set()});
    const idleWeapon = run(weapons, idleSwitch);
    idleSwitch.hero = 'Brigitte'; idleSwitch.firing = true; idleSwitch.buttons.add('Primary Fire'); idleWeapon.resume();
    assert.equal(idleSwitch.player[slot('augmentWeaponProfile')][0], 'Brigitte', 'Sample the weapon after an idle hero switch');
    idleSwitch.time = idleWeapon.deadline(); idleWeapon.resume();
    assert.equal(idleSwitch.damage.length, 2); assert(idleSwitch.damage.every(hit => hit.amount === 45));
    const queen = weaponState('Junker Queen', 5, {firing: false, ability2: true});
    assert(!applies(compiled.get(quick), {...queen, meleeing: true}));
    const axe = run(carnage, queen); queen.time = axe.deadline(); axe.resume();
    assert.equal(queen.damage.length, 2); assert(queen.damage.every(event => event.amount === 90));
    assert.deepEqual(array(queen.player[slot('enhancementPyroHitList')]).map(target => target.id), [2]);
    queen.time += 5; axe.resume(); assert.equal(queen.damage.length, 2, 'One Carnage cast must only extend once');
    for (const stop of [s => {s.ability2 = false;}, s => {s.alive = false;}, s => s.status.add('Stunned'), s => {s.hero = 'Ana';}]) {
        const state = weaponState('Junker Queen', 5, {firing: false, ability2: true}), task = run(carnage, state);
        stop(state); state.time += 0.75; task.resume(); assert.equal(state.damage.length, 0, 'Cancelled Carnage cannot hit remotely');
    }
    const vendettaSwing = scenario(4, {hero: 'Vendetta', meleeing: true, firing: true});
    assert(!applies(compiled.get(quick), vendettaSwing));
    assert(applies(compiled.get(sword), vendettaSwing), 'Sword and quick melee handlers must not overlap');
    const repeatState = (overrides = {}) => {
        const state = scenario(4, {hero: 'Vendetta', firing: true,
            targets: [{id: 'sword target', position: [0, 0, 6], alive: true, visible: true}], ...overrides});
        run('PLAYER AUGMENT INITIALIZATION', state);
        return state;
    };
    const nextWait = (state, task) => {state.time = task.deadline(); task.resume();};
    {
        const interval = 0.6, state = repeatState(), task = run(sword, state);
        for (let hit = 0; hit < 5; hit++) {
            if (hit > 0) nextWait(state, task); // Recovery ends; the next windup begins.
            assert.equal(state.damage.length, hit);
            state.time = task.deadline() - 1e-6; task.resume();
            assert.equal(state.damage.length, hit, 'No damage before the windup completes');
            nextWait(state, task);
            assert.equal(state.damage.length, hit + 1, 'Holding primary fire repeats without a false/true edge');
            assert(Math.abs(state.damage[hit].time - (100.15 + hit * interval)) < 1e-9);
        }
        assert.equal(state.effects.length, 5);
    }
    for (const stop of [s => s.buttons.clear(), s => {s.blocking = true;}, s => {s.ability = true;},
        s => {s.ultimate = true;}, s => {s.alive = false;}, s => {s.hero = 'Ana';},
        s => {s.firing = false;}, s => {s.globals.isGameplayActive = false;}]) {
        const state = repeatState(), task = run(sword, state);
        nextWait(state, task); assert.equal(state.damage.length, 1);
        state.time += 0.1; stop(state); task.resume();
        state.time += 5; task.resume(); assert.equal(state.damage.length, 1);
        assert.equal(task.done(), !applies(compiled.get(sword), state),
            'Release waits for a fresh click; an invalid actor exits without another hit');
    }
    const released = repeatState(), releasedTask = run(sword, released);
    nextWait(released, releasedTask);
    released.buttons.clear(); releasedTask.resume(); assert(!releasedTask.done());
    released.buttons.add('Primary Fire');
    const restarted = releasedTask; restarted.resume();
    nextWait(released, restarted); assert.equal(released.damage.length, 2, 'A new press starts a new windup');
    released.targets = [{id: 'new target', position: [0, 0, 7], alive: true, visible: true}];
    nextWait(released, restarted); nextWait(released, restarted);
    assert.equal(released.damage.at(-1).targets[0].id, 'new target', 'Every repeat queries current targets');
    for (const firingStopsOnRelease of [false, true]) {
        const state = repeatState(), task = run(sword, state);
        for (let click = 0; click < 3; click++) {
            if (click > 0) {
                state.buttons.add('Primary Fire'); state.firing = true; task.resume();
            }
            state.time += 0.02;
            state.buttons.clear(); state.firing = !firingStopsOnRelease; task.resume();
            assert.equal(state.damage.length, click, 'A short click must still respect the windup');
            nextWait(state, task);
            assert.equal(state.damage.length, click + 1, 'Releasing input must not cancel a committed swing');
            state.time += 1; task.resume();
            assert.equal(state.damage.length, click + 1, 'A released click must not auto-repeat');
        }
        assert.equal(state.effects.length, 3);
    }
    for (const stop of [s => {s.blocking = true;}, s => {s.ability = true;}, s => {s.ultimate = true;},
        s => {s.alive = false;}, s => {s.hero = 'Ana';}, s => {s.globals.isGameplayActive = false;},
        s => s.status.add('Stunned'), s => s.status.add('Asleep'), s => s.status.add('Frozen'),
        s => s.status.add('Knocked Down')]) {
        const state = repeatState(), task = run(sword, state);
        state.time += 0.02; state.buttons.clear(); stop(state); task.resume();
        assert(task.done(), 'A real interruption still cancels a short-click windup');
        assert.equal(state.damage.length, 0);
        assert.equal(state.effects.length, 0);
    }
    const kevlar = scenario(1); kevlar.player.initialMaxHealth = 250;
    run('PLAYER AUGMENT INITIALIZATION', kevlar); assert.equal(kevlar.armor, 75);
    for (const picked of [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]) for (const missing of [false, true]) {
        const state = scenario(0, {randomRoll: picked}); state.player.initialMaxHealth = 250;
        if (missing) delete state.player.augmentId;
        run('PLAYER AUGMENT INITIALIZATION', state);
        assert.equal(state.player.augmentId, picked, 'Unselected and late-join players can receive every real Augment');
        assert.equal(state.armor, picked === 1 ? 75 : 0);
        assert.deepEqual(state.randomCalls, [[1, 10]], 'No Preference is excluded from the random range');
        state.randomRoll = picked === 6 ? 1 : 6;
        run('PLAYER AUGMENT INITIALIZATION', state);
        assert.equal(state.player.augmentId, picked, 'Respawn/reinitialization retains the previously rolled ID');
        assert.equal(state.randomCalls.length, 1);
    }
    for (const selected of [2, 3, 4, 5, 6, 7, 8, 9, 10]) {
        const chosen = scenario(selected); chosen.player.initialMaxHealth = 250;
        run('PLAYER AUGMENT INITIALIZATION', chosen);
        assert.equal(chosen.player.augmentId, selected, 'Keep an explicit Augment selection');
        assert.equal(chosen.armor, 0);
        assert.deepEqual(chosen.randomCalls, [], 'Explicit Augment choices must not roll a replacement');
    }
    // Execute the compiled selection guard before enhancement-specific setup;
    // the remaining initialization branches are independently preserved in regressions.
    const enhancementInit = compiled.get('PLAYER ENHANCEMENT INITIALIZATION');
    const selectionActions = actions(enhancementInit).slice(0, 2);
    assert(selectionActions[0].startsWith('Skip If('));
    assert(selectionActions[1].startsWith('Set Player Variable(Event Player, enhancementId, Random Integer('));
    const enhancementSelection = {...enhancementInit,
        body: enhancementInit.body.split('actions {\n')[0] + 'actions {\n' + selectionActions.join('\n') + '\n}'};
    for (let picked = 1; picked <= enhancementCount; picked++) for (const missing of [false, true]) {
        const state = scenario(1, {randomRoll: picked});
        if (!missing) state.player.enhancementId = 0;
        start(enhancementSelection, state, compiled);
        assert.equal(state.player.enhancementId, picked, 'All enhancements are eligible for unselected / late-join players');
        assert.deepEqual(state.randomCalls, [[1, enhancementCount]]);
        state.randomRoll = picked === 10 ? 1 : 10;
        start(enhancementSelection, state, compiled);
        assert.equal(state.player.enhancementId, picked, 'An already resolved enhancement is retained');
        assert.equal(state.randomCalls.length, 1);
        const explicit = scenario(1, {randomRoll: 1}); explicit.player.enhancementId = picked;
        start(enhancementSelection, explicit, compiled);
        assert.equal(explicit.player.enhancementId, picked); assert.deepEqual(explicit.randomCalls, []);
    }
    for (const removed of ['Default Augment', 'Default Enhancement', 'Vendetta Long Reach Interval']) {
        assert(!build.result.includes(removed), removed + ' must not remain in the compiled Workshop settings');
    }
    assert(!files['variables.opy'].includes('augmentSwordRecovery'), 'Fixed timing needs no cached player variable alias');
    assert(!files['enhancements.opy'].includes('Enhancement.KEVLAR'));
    // Barrier geometry and cooldown remain live across waits and effect reevaluation.
    // They must never alias an enhancement that can now be selected alongside it.
    const enhancementSlots = new Set([...files['variables.opy'].matchAll(/^#!define enhancement\w+ (\w+)$/gm)].map(m => m[1]));
    for (const field of ['Facing', 'EdgeDirection', 'PlacementCooldown', 'Position', 'Corner1', 'Corner2', 'TargetList']) {
        assert(!enhancementSlots.has(slot('augmentBarrier' + field)), 'Barrier conflicts with enhancement storage: ' + field);
    }
    assert(!files['enhancements.opy'].includes('LASER_BARRICADE'));
    for (const name of ['LASER BARRICADE (PLACEMENT)', 'LASER BARRICADE BLOCKS ZOMBIES']) {
        const body = compiled.get(name).body;
        assert(body.includes('(Event Player).augmentId == 7;'));
        if (name === 'LASER BARRICADE (PLACEMENT)')
            assert(body.includes('Compare((Event Player).enhancementId, !=, 11)'), 'Only Dead Weight carry reserves a ready barricade press');
        else assert(!body.includes('(Event Player).enhancementId'));
    }
    const placement = compiled.get('LASER BARRICADE (PLACEMENT)').body;
    assert(placement.includes('Button(Interact)'));
    assert(!placement.includes('Button(Melee)'));
    const interactRule = compiled.get('PLAYER INTERACT (1: OPEN SUPPLY DROP, 2: PICK UP POWER UP, 3: USE POWER UP)');
    for (const crouch of [false, true]) for (const interact of [false, true]) {
        const state = scenario(7, {buttons: new Set([...(crouch ? ['Crouch'] : []), ...(interact ? ['Interact'] : [])])});
        assert.equal(applies(compiled.get('LASER BARRICADE (PLACEMENT)'), state), crouch && interact,
            'Barricade placement requires both buttons');
        assert.equal(applies(interactRule, state), interact && !crouch,
            'Barricade input must not also use or pick up a power up');
        state.player.augmentId = 1;
        assert.equal(applies(interactRule, state), interact, 'Other augments preserve crouched interaction');
    }

    // Execute the emitted use delay with the real interaction conditions. Stub only
    // the item-specific effects, recording whether powerUpUsage was reached.
    const interactActions = actions(interactRule);
    const useIndex = interactActions.indexOf('Call Subroutine(powerUpUsage);');
    assert(useIndex > 0);
    assert.equal(interactActions[useIndex - 2], 'Wait(0.25, Abort When False);');
    assert.equal(interactActions[useIndex - 1], 'If(Global.isGameplayActive);', 'Recheck phase after the hold now that it is absent from Conditions');
    const useOnly = {...interactRule, body: interactRule.body.split('actions {\n')[0]
        + 'actions {\n' + interactActions.slice(useIndex - 2, useIndex + 1).join('\n') + '\n}'};
    const useCompiled = new Map(compiled);
    useCompiled.set('powerUpUsage', {name: 'powerUpUsage',
        body: 'actions {\nSet Player Variable(Event Player, powerUpItemId, 0);\n}'});
    for (let item = 1; item <= 13; item++) {
        const held = scenario(7, {buttons: new Set(['Crouch', 'Interact'])});
        held.player.powerUpItemId = item;
        for (const seconds of [0, 0.25, 0.5, 1, 5, 30]) {
            held.time = 100 + seconds;
            assert(!applies(interactRule, held), 'Holding the combo must never start power-up use');
            assert.equal(held.player.powerUpItemId, item);
        }
        for (const pressAt of [0.01, 0.125, 0.249]) {
            const state = scenario(7, {buttons: new Set(['Interact'])});
            state.player.powerUpItemId = item;
            const task = start(useOnly, state, useCompiled);
            state.time += pressAt; state.buttons.add('Crouch'); task.resume();
            assert(task.done(), 'Adding Crouch must abort pending power-up activation');
            state.time = 101; task.resume();
            assert.equal(state.player.powerUpItemId, item, 'An aborted hold must not consume the item');
        }
        for (const [augment, crouch] of [[7, false], [1, true]]) {
            const state = scenario(augment, {buttons: new Set(['Interact', ...(crouch ? ['Crouch'] : [])])});
            state.player.powerUpItemId = item;
            const task = start(useOnly, state, useCompiled);
            state.time += 0.25; task.resume();
            assert(task.done());
            assert.equal(state.player.powerUpItemId, 0, 'Ordinary interaction must still reach power-up use');
        }
    }

    // Run the actual aiming controller, omitting only cosmetic feedback and stopping
    // before the placement raycast. Preview input is evaluated from the emitted beam.
    const placementRule = compiled.get('LASER BARRICADE (PLACEMENT)');
    const placementActions = actions(placementRule);
    const placementCheck = placementActions.indexOf('Call Subroutine(checkEnhancementPlacement);');
    assert(placementCheck > 0);
    const aimRule = {...placementRule, body: placementRule.body.split('actions {\n')[0]
        + 'actions {\n' + placementActions.slice(0, placementCheck)
            .filter(line => !line.startsWith('Play Effect(')).join('\n') + '\n}'};
    const preview = actions(compiled.get('PLAYER AUGMENT INITIALIZATION')).find(line => line.startsWith('Create Beam Effect('));
    const previewPredicate = args(args(preview)[0])[1];
    assert(!previewPredicate.includes('Button(Crouch)'), 'Preview must not require Crouch after aiming begins');
    const previewInput = args(previewPredicate)[0];
    assert(previewInput.includes('Compare((Event Player).augmentState2, ==, -1)'));
    const barrierCooldown = slot('augmentBarrierPlacementCooldown');
    for (const cooldown of [-2, -1, -0.5, 0, 1, 30])
    for (const interact of [false, true]) for (const crouch of [false, true]) {
        const state = scenario(7, {buttons: new Set([
            ...(interact ? ['Interact'] : []), ...(crouch ? ['Crouch'] : [])])});
        state.player[barrierCooldown] = cooldown;
        assert.equal(truth(value(previewInput, state)), cooldown === -1 && interact,
            'Preview requires the exact aiming latch and Interact, independently of Crouch');
        assert.equal(applies(placementRule, state), cooldown === 0 && crouch && interact,
            'A placement starts only when ready, never during aiming or cooldown');
    }
    for (const crouchReleasedAt of [0.1, 0.6]) {
        const state = scenario(7, {buttons: new Set(['Crouch', 'Interact'])});
        const task = start(aimRule, state, compiled);
        assert.equal(state.player[barrierCooldown], -1);
        assert(!applies(placementRule, state), 'Entering aim blocks another placement start without aborting the active controller');
        state.time += crouchReleasedAt; state.buttons.delete('Crouch'); task.resume();
        assert(!task.done(), 'Releasing Crouch must keep aiming active, including during the windup');
        state.time = 101; task.resume();
        assert(!task.done());
        assert(truth(value(previewInput, state)), 'Preview stays visible while Interact is held');
        assert(!applies(interactRule, state), 'Releasing Crouch while aiming must not activate a power up');
        state.buttons.delete('Interact'); task.resume();
        assert(task.done(), 'Releasing Interact completes aiming');
        assert.equal(state.player[barrierCooldown], 0);
        assert(!truth(value(previewInput, state)), 'Preview stops on release');
    }
    for (const cancelAt of [0.1, 0.6]) for (const death of [false, true]) {
        const state = scenario(7, {buttons: new Set(['Crouch', 'Interact'])});
        const task = start(aimRule, state, compiled);
        state.time += cancelAt; task.resume();
        if (death) state.alive = false; else state.buttons.delete('Interact');
        task.resume();
        assert(task.done(), 'Early release or death must end aiming');
        assert.equal(state.player[barrierCooldown], 0, 'Cancellation must clear the aiming latch');
    }
    assert(compiled.get('LASER BARRICADE BLOCKS ZOMBIES').body.includes(
        'Chase Player Variable At Rate(Event Player, augmentBarrierHealth, 10000, 500, None)'));

    assert(placement.includes('Set Player Variable(Event Player, augmentBarrierHealth, 10000)'));
    assert(placement.includes('Set Player Variable(Event Player, augmentState2, 30)'));
    const declarations = Object.values(files).join('\n');
    const variableBlocks = build.result.match(/variables \{\n    global:\n([\s\S]*?)\n    player:\n([\s\S]*?)\n\}/);
    assert(variableBlocks);
    const globalCount = [...variableBlocks[1].matchAll(/^\s+\d+: /gm)].length;
    const playerCount = [...variableBlocks[2].matchAll(/^\s+\d+: /gm)].length;
    assert(playerCount <= 128 && globalCount <= 128);
    assert.deepEqual([...declarations.matchAll(/^playervar (augment\w+)/gm)].map(m => m[1]),
        ['augmentId', 'augmentState0', 'augmentState1', 'augmentState2', 'augmentState3', 'augmentBarrierHealth']);
    if (process.argv.includes('--export')) {
        const exported = await compiler.compile(fs.readFileSync(path.join(root, 'main.opy'), 'utf8'),
            'en-US', root.replace(/\\/g, '/') + '/', 'main.opy');
        assert.deepEqual(exported.encounteredWarnings, []);
        assert.equal(exported.nbElements, build.elements);
        assert.deepEqual(rules(exported.result), parsed);
        fs.writeFileSync(path.join(root, 'main.ws.txt'), exported.result);
    }
    console.log(JSON.stringify({elements: build.elements, warnings: build.warnings.length,
        playerVariables: playerCount, globalVariables: globalCount, compiledRules: parsed.length, pickupCases, packChargeCases, meleeOverchargeCases,
        checked: ['Apothecary healing / infection / ultimate / no speed / saved pickup position including zero vector / single teleport charge / 1s hold / release-death-game-end cancellation / departure flash / Interact reservation', 'menu forward/reverse', 'Laser Barricade augment selection / independent storage / Crouch + Interact placement / release Crouch during windup and aiming / cancel and death cleanup / power up input exclusion / 10000 HP / 30s cooldown', 'Shock Landing name / second-jump/eight directions/45-degree diagonals/no direction means wave only/death/CC/cooldown/collision cleanup',
            'dash 13s cooldown / 0.5s phase / first landing wave / 40 damage to all targets including unpushable / Pyrotechnic actual-hit burns and 15m limit / lethal and invulnerable targets / 32 impulse at 6.5 degrees / early and late landing / radius / all directions / resistance / attribution / interrupts',
            'double jump airborne + grounded double-tap / ability-active launch / 14.4 impulse / 16s cooldown / shared gate / tap timeout / CC / landing / death',
            'double jump first-hit +50% / minimum damage 30 inclusive / smaller hits preserve bonus / native and script damage / flight / 0.5s landing window / expiry / no recursion / no rearm / death / hero switch', 'movement cooldown HUD',
            'grapnel 7-40m selection / live cable / moving target / velocity correction / melee combo / 35 impact damage / Pyrotechnic actual-hit burn / grounded 0.5s stun / airborne 3s knockdown / ground state sampled on arrival / launch sound / shared 0.4 impact / no arrival jump / 16s cooldown / misses / timeout / CC / death / hero switch / disconnect cleanup',
            'ammo respawn/hero/weapon/cache/spent rounds/single clip/reload input lifetime/native failure fallback/cancelled reload/empty boundary/dual clip',
            'quick melee x3 / 7.5m boundary / native range excluded / no scripted knockback or environmental credit / Vendetta x3 / LoS / cone / windup / all targets',
            'Reinhardt / Brigitte / D.Mon / Dragonblade / Nemesis / Forge Hammer x3 / held attacks / short clicks / forms / interrupts',
            'Carnage x3 / one hit per cast / cancelled casts', 'Pyrotechnic all targets / actual health loss / invulnerability / distance limit',
            'Vendetta held fire / short clicks / fixed 0.6s interval / interruptions / restart / target refresh',
            'random Enhancement + Augment / all real IDs / late join / retain rolls / preserve explicit selections / removed Workshop settings',
            'Overcharge health packs / receiver ownership / null-self-other attribution / both event orders / no double credit / fractional energy / gameplay gate / Apothecary / armed burst preserved',
            'Long Reach Overcharge / actual damage / immunity / mixed targets / first hit / multiple targets and swings / exact expiry / fixed window / independent next bank / scripted-event filtering'],
        exported: process.argv.includes('--export'), limitation: 'Game physics, native hitboxes and engine ammo support require an in-game check.'}, null, 2));
}
module.exports = {value, applies, execute, start, scenario, actions, enhancementCount};
if (require.main === module) main().catch(error => {console.error(error); process.exitCode = 1;});
