# Zombie Survival Missions Reforged 2.0

**ZSM Reforged** is an Overwatch Workshop mod that reworks **Zombie Survival Missions Modded (ZSMM)** by **Kamenrider#11346**. It is based on the **786TW** snapshot from **October 30, 2026**. **Mazattack#1183** created the original Zombie Survival Missions. [Zombie Survival Missions Modded (786TW)](https://workshop.codes/786tw)

## Using the mod code

Compile the source into Workshop code using [OverPy](https://github.com/Zezombye/overpy). Its repository also provides documentation for the language. The compilation entry point is `main.opy` in the project root. The easiest way is to use the OverPy extension for Visual Studio Code.

1. Install Visual Studio Code and the OverPy extension by following the [installation instructions](https://github.com/Zezombye/overpy#installation).
2. Open the project folder in VS Code, then open the root `main.opy` file.
3. Save `main.opy` (`Ctrl+S`). The extension starts compilation; on success, the compiled code is copied to the clipboard and written to `main.ws.txt` in the project root.
4. In Overwatch, create a custom game, open its settings, and import the compiled code from the clipboard.

After changing the source, save the root `main.opy` again to compile the updated mod.

### Passive regeneration issue

Passive health regeneration for the zombie team is disabled under **Settings → Heroes → General → Team 2**. However, importing the source code into Workshop resets this setting, apparently due to a Workshop bug. **Manually disable passive regeneration for Team 2 after every code import**, before sharing the mod's short code.

## ZSM Reforged gameplay changes from ZSMM (**786TW**)

### Choosing abilities before the match

- Each survivor now has two independent ability slots. Press **Quick Melee** to choose an **Enhancement** and **Interact** to choose an **Augment**. There are **13 Enhancements and 10 Augments**.
- Leave a slot on **No Preference** to get a random ability. This also applies when joining a match in progress.

### Enhancements

| Enhancement | Changes |
| --- | --- |
| **Zombie Hybrid** | Zombie bites can infect you even when temporary health or armor puts you above your normal health. Double-tap **Crouch** to detonate. Only tanks can roll this Enhancement at random. |
| **Bulking Season** | Each elimination adds **0.75% max health** and **0.75% size**, up to **2.5× health** and **2.5× size**. Your voice deepens as you grow. On death, 60% of stacks remain, rounded down. Double-tap **Crouch** to toggle the size and voice effects. You keep the health bonus either way. Only tanks can roll this Enhancement at random. |
| **Born to Battle** | The first final blow grants one ability cooldown reset. Three more final blows before spending it grant a second. Spending a reset clears partial progress toward the second. As in the original mod, most abilities can be reset, with a few exceptions due to Workshop bugs. |
| **Charge Battery** | Starting your ultimate grants **No Cooldowns for 8 seconds** or refreshes the timer to 8 seconds if less time remains. |
| **Wrestler** | Press **Interact** to grab a stunned, sleeping, frozen, or knocked-down zombie within **5 m**. Hold a regular zombie for up to **4 seconds**, or a boss or miniboss for up to **1 second**. Press **Interact** again to throw it for **100 damage**. The throw pushes other zombies within **10 m** and up to **90° off the crosshair**, dealing **35 damage** to each. Double-tap **Crouch** to pull a zombie from up to **20 m** away, deal **75 damage**, and knock it down for **2 seconds**. Bosses and minibosses take the damage and fall in place. The pull has a **16-second cooldown**. Jetpack Cat cannot use **Frenetic Flight** while holding a zombie. |
| **Bolt Strike** | Aim at a visible zombie within **45 m** and double-tap **Crouch**. Lightning deals **200 damage** to the target and **75 damage** to other visible zombies within **10 m** of it. All targets hit are stunned for **1.5 seconds**. **20-second cooldown.** |
| **Engineer** | Gain **10 scrap** when a zombie dies within **20 m**, **15** per assist, and **1 per second** while alive. Double-tap **Crouch** to grant up to **75 armor** for **35 scrap** to an ally or **70 scrap** to yourself, capped at **200 armor per player**. Hold **Melee** for **0.25 seconds** to deploy a turret for **350 scrap**. Your turrets, including those from supply drops, have about a **4.8% chance per hit** to freeze a target for **2 seconds**. |
| **Auspex Scan** | Aim at a surface or zombie within **30 m** and double-tap **Crouch**. The pulse passes through walls in an **8 m radius**, marking and hacking zombies for **6 seconds**. The objective boss is marked without being hacked. Survivors deal **40% more damage** to marked targets, including minibosses, or **20% more** to objective bosses and the Zombie Egg. The latest caster gains **0.2 percentage points of ultimate charge** per point of bonus damage dealt by allies. **15-second cooldown.** |
| **Plague Doctor** | Heal for **50% more**, or **87.5% more** when healing infected targets. Restoring health reduces your own infection if you're infected. It also reduces infection in recipients who are infected and don't have **Zombie Hybrid**. **Beacon of Healing** stacks with **Plague Doctor** and **Overcharge**. Only supports can roll this Enhancement at random. |
| **Overcharge** | New Enhancement. Increases healing dealt by **15%**. Gain 1 energy per 2.7 HP healed, including health packs, and 10 energy per assist. Double-tap **Crouch** to spend up to 100 energy on bonus damage. Your next hit opens a **0.3-second** window in which the bonus applies to every hit. Unspent energy stays available. Only supports can roll this Enhancement at random. |

#### Born to Battle limitations

Known cooldown reset issues affect **D.Va's Micro Missiles**, **Ramattra's Void Barrier**, **Genji's Swift Strike**, **Soldier: 76's Helix Rockets**, **Tracer's Recall**, **Baptiste's Immortality Field**, and **Lifeweaver's Rejuvenating Dash**. Born to Battle also can't refill **Roadhog's Take a Breather**. [Workshop bug report](https://us.forums.blizzard.com/en/overwatch/t/workshop-ability-cooldown-showing-incorrect-values/854487)

### Augments

| Augment | Effect |
| --- | --- |
| **Kevlar** | Moved to the Augment slot. Grants **75 recoverable armor** and **50% knockback resistance**. After a qualifying nonlethal hit from a zombie's weapon or ability, you regain **50% of the damage taken**. |
| **Dash** | Double-tap **Jump** to dash in your movement direction. Stores **two charges** and restores one every **14 seconds**. For **1.7 seconds**, you have **100% damage resistance** and immunity to regular knockback. Zombie bites can't add infection stacks or apply damage over time, and zombie attacks can't ignite you. Existing effects stay active. |
| **Highrise** | Double-tap **Jump** to launch upward from the ground or in midair. Deal **55% more damage** until you land or **5 seconds** pass, plus **0.1 seconds** afterward. **14-second cooldown.** |
| **Telekinesis** | Triples melee reach. Weapon hits at extended range deal **75% of normal damage**. **Crouch + Jump** pushes visible regular zombies within **10 m** and deals **35 damage** to them. **15-second cooldown.** |
| **Ammo Pack** | Doubles magazine capacity. Reloading or activating your Ultimate refills the magazine. Does not work for Wuyang, Mauga, Jetpack Cat, or D.Mon (Pilot Form). |
| **Grapnel Launcher** | **Crouch + Jump** pulls you toward an ally or zombie **7–45 m** away. On arrival, a wave from the target knocks back surrounding zombies within **10 m** and deals **30 damage** to each. A direct hit on a zombie deals **75 damage**, stuns grounded targets for **1 second**, and knocks down airborne targets for **3 seconds**. Hold **Jump** to launch upward on arrival. **12-second cooldown.** |
| **Laser Barricade** | Moved to the Augment slot. Hold **Crouch + Interact** to aim, then release **Interact** to place the wall. Width increased from **5 to 6 m**, cooldown reduced from **30 to 25 seconds**, and contact damage to zombies increased from **10 to 20**. For every **4,900 damage** a zombie deals to the wall on contact, it is knocked down for **1 second**. |
| **Scavenger** | Gives you two extra power-up slots. When a zombie dies within **20 m**, you have a **5% chance** to receive a power-up. Loot fills your active slot first, then your backpack. **Crouch + Interact** stows a power-up or cycles your slots. Death or a manual drop empties your inventory onto the ground. |
| **Survivalist** | Grants **50 recoverable health** and heals you for **12% of damage dealt**, including damage from power-ups and Enhancements. Lifesteal benefits from **Plague Doctor** healing bonuses. |
| **Hitchhiker** | Press **Crouch + Jump** to ride a nearby eligible ally closest to your aim or to dismount. Each player can belong to one pair. While attached, both players gain bonus HP equal to their partner's base max HP and share a health percentage. The bonus HP pools expire on detach. Reattaching has a **1.5-second cooldown**. Mei's **Cryo-Freeze** is disabled while she rides. Select Hitchhiker manually. |

### Combat, zombies, and power-ups

- **Take 35% less damage while using your ultimate.** Zombie bites can't add infection stacks or apply damage over time, and zombie attacks can't ignite you. Existing effects stay active.
- Tanks deal **88%** of their base damage, and Damage heroes deal **94%**.
- **Carrion (Jetpack Cat)** is a new regular zombie. It attacks from the air, can use its ultimate, and can carry other zombies that request a ride. It appears in **All Zombies**, **New Blood**, and **What’ll it be?**
- **Cure+ combines Cure and Vaccine.** It clears active infection. If you're uninfected, it grants **1.5 levels of protection** against future bites.
- **Bounce Pad** has been removed from the power-up pool.
- The default zombie count increased from **6 to 7**.
- Supply drops now contain **6 power-ups instead of 5** by default.

### Hero changes

- **Soldier: 76** deals **50% more damage** while Tactical Visor is active.
- **Cassidy** stuns targets hit by Flashbang for **0.8 seconds**.
- **Brigitte** stuns targets hit by Shield Bash for **0.8 seconds**.
- **Reinhardt** stuns targets for **0.6 seconds** when he damages them with his shield raised.
- **D.Mon** stuns targets for **0.6 seconds** when Surging Strike deals damage.

### Objectives and extraction

- **Players who die in the first 10 seconds of the match automatically revive as soon as they go down.** If the whole team goes down during that window, the match continues.
- **Completing an objective gives the team more time to rescue downed players.** It adds the full current rescue allowance, between **30 and 60 seconds**, to each downed player's active timer. For example, **12 seconds** remaining with a **60-second** allowance becomes **72 seconds**.

### Camera and HUD

- **Reload + Crouch + Jump** switches between the standard camera and the third-person camera. Camera distance scales with hero size. Aiming temporarily restores the standard camera for **Ana, Ashe, Widowmaker, Emre, and Freja**.
- The team HUD now shows each player's Enhancement and Augment icons.
- The redesigned ability HUD shows charges, cooldown timers, and control hints. Ability names change color to show their current status.
- The selected **Challenge** and **Zombie Mod** are displayed during the match.

## Resources

The [workshop-snapshots](workshop-snapshots/) directory contains exports of ZSMM and other mods, along with their OverPy decompilations. These snapshots are used for comparison and as reference material.
