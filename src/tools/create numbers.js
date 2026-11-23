// Share the extended weapon damage rate with Carnage and the voting HUD.
const telekinesisExtendedWeaponDamagePct = 75;
let result = `\n  #!define TELEKINESIS_EXTENDED_WEAPON_DAMAGE_PCT ${telekinesisExtendedWeaponDamagePct}\n`;

// This order also indexes the per-hero stat tables.
const zombieSpawnHeroes = [
  "REAPER", "JUNKRAT", "TORBJORN", "ROADHOG", "REINHARDT", "ANRAN",
  "WIDOWMAKER", "MAUGA", "MERCY", "WRECKING_BALL", "MOIRA", "PHARAH",
  "SIGMA", "JUNKER_QUEEN", "ILLARI", "HAZARD", "SYMMETRA", "ANA",
  "WINSTON", "DOOMFIST", "KIRIKO", "JETPACK_CAT",
];

// Carrion is appended at hero index 21; earlier indices and zero weights stay unchanged.
// All Zombies: Carrion matches Reinhardt (3/103, about 2.91%); other relative weights are preserved.
// Six-decimal weights sum to 100; rounding residue is assigned to Reaper. New Blood reserves 20%.
// Its difficulty stats come from Jetpack Cat (index 5) in the ZSMM-remixed snapshot.
const numbers = [
  { // Spawn rates: All Zombies
    spawnMode: 1,
    list: [10.679613, 9.708738, 4.854369, 3.883495, 2.912621, 4.854369, 3.883495, 3.883495, 5.825243, 2.912621, 4.854369, 5.825243, 2.912621, 3.883495, 3.883495, 5.825243, 3.883495, 8.737864, 3.883495, 0, 0, 2.912621],
  },

  { // Spawn rates: New Blood
    spawnMode: 2,
    list: [0, 0, 0, 0, 0, 8.08, 0, 8, 1.6, 1.6, 1.6, 3.12, 8, 8, 8, 8, 8, 8, 8, 0, 0, 20],
  },

  { // Spawn rates: Zombie Shuffle
    spawnMode: 4,
    shuffledWeightCount: 19,
    list: [50, 25, 15, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  },

  { // Spawn rates: Dinner Rush
    spawnMode: 5,
    list: [0, 0, 15, 0, 0, 16, 15, 4, 0, 3, 15, 9, 0, 3, 10, 0, 10, 0, 0, 0, 0, 0],
  },

  { // Spawn rates: Ham N Hammer
    spawnMode: 6,
    list: [0, 0, 0, 0, 50, 0, 0, 0, 0, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  },

  { // Bot health: Insanity
    offset: "NL_BOT_HEALTH_INSANITY_OFFSET",
    len: "NL_BOT_HEALTH_INSANITY_LEN",
    list: [300, 250, 200, 900, 1500, 220, 250, 900, 250, 700, 200, 350, 350, 700, 350, 400, 275, 250, 1000, 0, 0, 220],
  },

  { // Bite damage: Insanity
    offset: "NL_BITE_DAMAGE_INSANITY_OFFSET",
    len: "NL_BITE_DAMAGE_INSANITY_LEN",
    list: [48, 30, 45, 75, 0, 20, 35, 51, 45, 50, 110, 80, 65, 0, 30, 55, 35, 30, 30, 80, 80, 20],
  },

  { // Bite durations: Insanity
    offset: "NL_BITE_DURATIONS_INSANITY_OFFSET",
    len: "NL_BITE_DURATIONS_INSANITY_LEN",
    list: [3, 3, 3, 3, 0, 1.5, 4, 3, 2, 2, 1, 0, 2, 0, 3, 3, 3, 3, 3, 3, 3, 1.5],
  },

  { // Damage dealt: INSANITY
    offset: "NL_DAMAGE_DEALT_INSANITY_OFFSET",
    len: "NL_DAMAGE_DEALT_INSANITY_LEN",
    list: [200, 300, 175, 150, 200, 100, 150, 90, 300, 175, 200, 150, 150, 190, 175, 125, 200, 240, 200, 180, 300, 180],
  },

  { // Bot health: 1-4 players
    offset: "NL_BOT_HEALTH_BASE_OFFSET",
    len: "NL_BOT_HEALTH_BASE_LEN",
    list: [225, 170, 125, 900, 2000, 160, 140, 700, 160, 650, 135, 275, 400, 650, 275, 225, 170, 170, 500, 0, 0, 160],
  },

  { // Bite durations: 3+ players
    offset: "NL_BITE_DURATIONS_BASE_OFFSET",
    len: "NL_BITE_DURATIONS_BASE_LEN",
    list: [3, 3, 3, 3, 0, 1.5, 4, 2, 2, 2, 1, 0, 2, 0, 3, 3, 3, 3, 3, 3, 3, 1.5],
  },

  { // Bite damage: Normal
    offset: "NL_BITE_DAMAGE_NORMAL_OFFSET",
    len: "NL_BITE_DAMAGE_NORMAL_LEN",
    list: [5, 2.5, 2, 20, 15, 3, 2, 7.5, 5, 10, 10, 30, 10, 15, 5, 5, 5, 2.5, 10, 10, 10, 3],
  },

  { // Bite durations: Normal
    offset: "NL_BITE_DURATIONS_NORMAL_OFFSET",
    len: "NL_BITE_DURATIONS_NORMAL_LEN",
    list: [1, 1, 1.5, 1.5, 0, 0.5, 1.5, 1, 1, 0.5, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0.5],
  },

  { // Throttle speeds: NORMAL
    offset: "NL_THROTTLE_SPEEDS_NORMAL_OFFSET",
    len: "NL_THROTTLE_SPEEDS_NORMAL_LEN",
    list: [0.75, 0.8, 0.9, 0.5, 0.6, 0.6, 0.3, 0.65, 0.6, 0.55, 0.8, 0.55, 0.55, 0.65, 0.5, 0.55, 0.5, 0.8, 0.9, 0.6, 0.6, 0.7],
  },

  { // Damage dealt: NORMAL
    offset: "NL_DAMAGE_DEALT_NORMAL_OFFSET",
    len: "NL_DAMAGE_DEALT_NORMAL_LEN",
    list: [8.5, 7.5, 1, 1, 50, 8, 1, 25, 1, 50, 1, 75, 25, 50, 25, 8.5, 5, 7.5, 50, 50, 50, 25],
  },

  { // Bite damage: Hard
    offset: "NL_BITE_DAMAGE_HARD_OFFSET",
    len: "NL_BITE_DAMAGE_HARD_LEN",
    list: [15, 10, 12, 40, 30, 5, 2, 12, 15, 20, 15, 45, 20, 30, 7, 15, 7, 10, 10, 20, 20, 7],
  },

  { // Bite durations: Hard
    offset: "NL_BITE_DURATIONS_HARD_OFFSET",
    len: "NL_BITE_DURATIONS_HARD_LEN",
    list: [2.5, 2.5, 3, 3, 0, 1.5, 4, 2, 2, 2, 1, 0, 2, 0, 3, 2.5, 3, 2.5, 3, 3, 3, 1.5],
  },

  { // Throttle speeds: HARD
    offset: "NL_THROTTLE_SPEEDS_HARD_OFFSET",
    len: "NL_THROTTLE_SPEEDS_HARD_LEN",
    list: [0.85, 0.9, 1, 0.6, 0.7, 0.6, 0.4, 0.75, 0.7, 0.65, 0.9, 0.65, 0.65, 0.75, 0.6, 0.65, 0.6, 0.9, 1, 0.7, 0.7, 0.8],
  },

  { // Damage dealt: HARD
    offset: "NL_DAMAGE_DEALT_HARD_OFFSET",
    len: "NL_DAMAGE_DEALT_HARD_LEN",
    list: [67, 66, 25, 25, 90, 12, 25, 50, 25, 100, 25, 75, 50, 75, 50, 50, 50, 66, 75, 75, 75, 40],
  },

  { // Bot health: Legendary
    offset: "NL_BOT_HEALTH_LEGENDARY_OFFSET",
    len: "NL_BOT_HEALTH_LEGENDARY_LEN",
    list: [300, 200, 125, 900, 2000, 180, 150, 800, 200, 750, 175, 300, 400, 750, 300, 350, 200, 200, 1100, 0, 0, 180],
  },

  { // Bite damage: Legendary
    offset: "NL_BITE_DAMAGE_LEGENDARY_OFFSET",
    len: "NL_BITE_DAMAGE_LEGENDARY_LEN",
    list: [42, 22, 25, 55, 50, 20, 20, 40, 35, 25, 90, 70, 50, 50, 20, 40, 20, 22, 25, 40, 40, 20],
  },

  { // Throttle speeds: LEGENDARY
    offset: "NL_THROTTLE_SPEEDS_LEGENDARY_OFFSET",
    len: "NL_THROTTLE_SPEEDS_LEGENDARY_LEN",
    list: [0.9, 0.95, 1, 0.75, 0.85, 0.8, 0.7, 0.8, 0.8, 0.75, 0.9, 0.65, 0.85, 0.8, 0.75, 0.9, 0.8, 0.95, 1, 0.9, 0.9, 0.9],
  },

  { // Damage dealt: LEGENDARY
    offset: "NL_DAMAGE_DEALT_LEGENDARY_OFFSET",
    len: "NL_DAMAGE_DEALT_LEGENDARY_LEN",
    list: [100, 150, 100, 100, 170, 75, 100, 80, 100, 175, 50, 100, 100, 140, 125, 90, 150, 125, 125, 150, 150, 100],
  },

  { // Bite damage: Expert
    offset: "NL_BITE_DAMAGE_EXPERT_OFFSET",
    len: "NL_BITE_DAMAGE_EXPERT_LEN",
    list: [30, 15, 20, 50, 40, 15, 17.5, 30, 30, 20, 40, 60, 40, 40, 10, 40, 10, 15, 15, 20, 20, 15],
  },

  { // Throttle speeds: EXPERT
    offset: "NL_THROTTLE_SPEEDS_EXPERT_OFFSET",
    len: "NL_THROTTLE_SPEEDS_EXPERT_LEN",
    list: [0.85, 0.9, 1, 0.6, 0.7, 0.7, 0.4, 0.75, 0.7, 0.65, 0.9, 0.65, 0.65, 0.75, 0.6, 0.85, 0.7, 0.9, 1, 0.7, 0.7, 0.8],
  },

  { // Damage dealt: EXPERT
    offset: "NL_DAMAGE_DEALT_EXPERT_OFFSET",
    len: "NL_DAMAGE_DEALT_EXPERT_LEN",
    list: [90, 125, 50, 50, 130, 40, 50, 50, 50, 150, 1, 75, 75, 90, 75, 85, 100, 125, 100, 100, 100, 75],
  },
  { // Telekinesis: [native range, damage, windup, recovery], in TELEKINESIS_MELEE_WEAPON_HEROES order.
    // Append new groups to preserve all earlier offsets. Genji's recovery is a
    // placeholder: compressed() rounds to 3 decimals, so its exact formula stays in OverPy.
    offset: "NL_TELEKINESIS_PROFILE_OFFSET",
    len: "NL_TELEKINESIS_PROFILE_LEN",
    list: [
      [4, 100, 0.4, 0.56], // Reinhardt
      [6, 45, 0.2, 0.4], // Brigitte
      [4, 60, 0.2, 0.456], // D.Mon
      [5, 100, 0.15, 0], // Genji
      [10, 65, 0.15, 0.45], // Ramattra
      [2.5, 70, 0.35, 0.35], // Torbjorn
      [4.3, 45, 0.15, 0.45], // Vendetta
    ].flatMap(([range, damage, windup, recovery]) => [
      range, damage * telekinesisExtendedWeaponDamagePct / 100, windup, recovery,
    ]),
  },
  { // Equal spawn rates: 19 original heroes and Carrion at index 21.
    spawnMode: 3,
    list: [...Array(19).fill(5), 0, 0, 5],
  },
];

// Augment IDs still index the first ten colors directly.
const sharedColorPalette = [
  "AQUA", "LIGHT_GRAY", "YELLOW", "SKY_BLUE", "ORANGE", "WHITE",
  "TURQUOISE", "BLUE", "LIME_GREEN", "RED", "GREEN", "PURPLE", "GRAY", "ROSE", null,
];

// Rows follow item ID - 1 or the raw menu selection ID. Keep the gaps in Objective.
const colorPalettes = {
  POWERUP: ["GREEN", "YELLOW", "BLUE", "RED", "ORANGE", "YELLOW", "ORANGE", "BLUE", "RED", "PURPLE", "RED", "WHITE"],
  ZOMBIE_MENU: ["AQUA", "ORANGE", "RED", "PURPLE", "LIME_GREEN", "BLUE", "GRAY"],
  OBJECTIVE_MENU: ["AQUA", "ORANGE", "RED", null, null, "RED", "LIME_GREEN", "TURQUOISE", null, "PURPLE"],
  ENHANCEMENT_MENU: ["AQUA", "GRAY", "LIME_GREEN", "RED", "ORANGE", "GRAY", "WHITE", "BLUE", "SKY_BLUE", "YELLOW", "ROSE", "GREEN", "TURQUOISE", "PURPLE"],
  CHALLENGE_TITLE: ["AQUA", "YELLOW", "LIME_GREEN", "ORANGE", "TURQUOISE", "PURPLE"],
};

for (const [name, palette] of Object.entries(colorPalettes)) {
  const indices = palette.map(color => sharedColorPalette.indexOf(color));
  if (indices.includes(-1)) {
    throw new Error(`Color missing from the shared palette: ${name}`);
  }
  numbers.push({
    offset: `NL_${name}_COLORS_OFFSET`,
    len: `NL_${name}_COLORS_LEN`,
    list: indices,
  });
}

const spawnHeroIndexTables = {
  BOSS_EXCLUDED_HERO: [
    "JUNKRAT", "ANRAN", "WIDOWMAKER", "JUNKER_QUEEN", "SYMMETRA", "ANA",
    "DOOMFIST", "KIRIKO", "MAUGA", "SIGMA", "WRECKING_BALL", "JETPACK_CAT",
  ],
  // Ham N' Hammer draws from the first two entries only.
  MINIBOSS_HERO: [
    "REINHARDT", "WRECKING_BALL", "JUNKER_QUEEN", "DOOMFIST",
    "KIRIKO", "MAUGA", "HAZARD", "REAPER",
  ],
};

for (const [name, heroes] of Object.entries(spawnHeroIndexTables)) {
  const indices = heroes.map(hero => {
    const index = zombieSpawnHeroes.indexOf(hero);
    if (index === -1) {
      throw new Error(`Hero missing from zombie spawn list for ${name}: ${hero}`);
    }
    return index;
  });
  numbers.push({ offset: `NL_${name}_OFFSET`, len: `NL_${name}_LEN`, list: indices });
}

const spawnModeOffsets = [0];
const spawnModeWeightTotals = [0];
let numberIndex = 0;
numbers.forEach(group => {
  result += "\n";
  if (group.spawnMode) {
    if (group.list.length !== zombieSpawnHeroes.length) {
      throw new Error(`Zombie spawn mode ${group.spawnMode} has ${group.list.length} weights for ${zombieSpawnHeroes.length} heroes`);
    }
    spawnModeOffsets[group.spawnMode] = numberIndex;
    // Match compressed() by rounding each weight to three decimal places before summing.
    const totalInThousandths = group.list.reduce((sum, weight) => sum + Math.round(weight * 1000), 0);
    spawnModeWeightTotals[group.spawnMode] = totalInThousandths / 1000;
  }
  if (group.shuffledWeightCount) {
    const fixedWeights = group.list.slice(group.shuffledWeightCount);
    result += `  #!define NL_ZOMBIE_SHUFFLE_WEIGHT_COUNT ${group.shuffledWeightCount}\n`;
    result += `  #!define NL_ZOMBIE_SHUFFLE_FIXED_WEIGHTS [${fixedWeights.join(", ")}]\n`;
  }
  if (group.offset) {
    result += `  #!define ${group.offset} ${numberIndex}\n`;
  }
  group.list.forEach(number => {
    result += `  ${number},\n`;
    numberIndex++;
  });
  if (group.len) {
    result += `  #!define ${group.len} ${group.list.length}\n`;
  }
});

result += `  #!define ZOMBIE_SPAWN_HEROES [${zombieSpawnHeroes.map(hero => "Hero." + hero).join(", ")}]\n`;
result += `  #!define ZOMBIE_SPAWN_HERO_COUNT ${zombieSpawnHeroes.length}\n`;
result += `  #!define NL_SPAWN_MODE_OFFSETS [${spawnModeOffsets.join(", ")}]\n`;
result += `  #!define NL_SPAWN_MODE_WEIGHT_TOTALS [${spawnModeWeightTotals.join(", ")}]\n`;
result += `  #!define SHARED_COLOR_PALETTE [${sharedColorPalette.map(color => color === null ? "null" : "Color." + color).join(", ")}]\n`;

result
