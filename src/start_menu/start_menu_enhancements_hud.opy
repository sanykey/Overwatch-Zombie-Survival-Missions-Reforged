#!mainFile "../../main.opy"

macro createStartMenuEnhancementHud():
    hudText(
        getPlayers(Team.1),
        "Enhancement: {0}{1}".format(
            [
                "No Preference", "Zombie Hybrid ", "Bulking Season ",
                "Brain Killer ", "Pyrotechnic ", "Born to Battle ",
                "Charge Battery ", "Hitchhiker ", "P.U.P. ", "Wrestler ",
                "Bolt Strike ", "Engineer ", "Plague Doctor ", "Overcharge "
            ][localPlayer.enhancementId],
            enhancementOptionList[localPlayer.enhancementId] if localPlayer.enhancementId > Enhancement.NO_PREFERENCE else ""
        ),
        [
            " ",
            "Gain infection faster and convert it into an explosion dealing 100 dmg per infection level.",
            "Each elimination: +0.5% max HP (up to 2x), +0.75% size (up to 2.5x). Lose half your stacks on death.",
            "Critical hits deal +60% dmg; +20% against bosses.",
            "Damaging zombies within 15m sets them on fire for 3s.",
            "Final blows store ability resets, up to 2. Your next ability use consumes a reset.",
            "Place a battery that grants 15% ultimate charge on contact. Recharges in 10s; placement cd: 20s. Using ultimate resets all ability cd.",
            "Ride a nearby teammate and share your combined health while attached.",
            "An autonomous drone burns and knocks down nearby zombies, or freezes distant targets and nearby zombies.",
            f"Grab disabled zombies; 50% dmg resist while carrying. Pull and knock down a zombie within {WRESTLER_PULL_RANGE}m; cd {WRESTLER_PULL_COOLDOWN}s.",
            f"Hits chain to {BOLT_STRIKE_CHAIN_TARGETS} zombies within {BOLT_STRIKE_RADIUS}m for {BOLT_STRIKE_CHAIN_DAMAGE_RATIO * 100}% dmg (max {BOLT_STRIKE_CHAIN_DAMAGE_MAX}).",
            f"Scrap: +{ENGINEER_COLLECTION_REWARD} per zombie death within {ENGINEER_COLLECTION_RANGE}m, +{ENGINEER_ASSIST_SCRAP} per assist, +{ENGINEER_SCRAP_PASSIVE_RATE}/s. Craft armor for yourself or allies (up to {ENGINEER_ARMOR_MAX} each) and freezing turrets.",
            "+30% healing, increased to +62.5% on infected allies. Healing reduces infection in you and infected allies.",
            "+15% healing. Bank healing/3 (packs included) +10 per assist. Double-tap Crouch: spend up to 100 energy for bonus dmg per hit."
        ][localPlayer.enhancementId],
        "Change Selection (Press [{0}])".format(inputBindingString(Button.MELEE)),
        HudPosition.ACTUALLY_LEFT,
        3,
        startMenuEnhancementColorList[localPlayer.enhancementId],
        startMenuEnhancementColorList[localPlayer.enhancementId],
        startMenuEnhancementColorList[localPlayer.enhancementId],
        HudReeval.VISIBILITY_STRING_AND_COLOR
    )
