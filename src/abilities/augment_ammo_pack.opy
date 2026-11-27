#!mainFile "../../main.opy"

subroutine refillAmmoPack

macro ammoPackCapacity():
    # An unlisted hero has index -1 and uses the leading zero.
    numbersList[(NL_AMMO_PACK_OFFSET + 1) + ammoPackHeroListConst.index(eventPlayer.getHero())]

macro ammoPackClip():
    # Kunai and Thorn Volley use the second clip.
    1 if eventPlayer.getHero() in [Hero.KIRIKO, Hero.LIFEWEAVER] else 0

rule "AMMO PACK MAGAZINES":
    @Event eachPlayer
    @Team 1
    # Native UI workaround: retain one phase/ID Condition.
    @Condition eventPlayer.augmentId == Augment.AMMO_PACK
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition ammoPackCapacity() >= 1

    eventPlayer.setMaxAmmo(evalOnce(ammoPackClip()), evalOnce(ammoPackCapacity()))
    refillAmmoPack()

rule "AMMO PACK REFILL":
    @Event eachPlayer
    @Team 1
    # Native UI workaround: retain one phase/ID Condition.
    @Condition eventPlayer.augmentId == Augment.AMMO_PACK
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isReloading() == true

    waitUntil(eventPlayer.isReloading() == false, Math.INFINITY)
    if eventPlayer.isAlive() and eventPlayer.hasSpawned():
        refillAmmoPack()


def refillAmmoPack():
    # Use one lookup per refill. The scratch slot is consumed without a wait.
    #!define ammoPackRefillCapacity tmp0
    ammoPackRefillCapacity = ammoPackCapacity()
    if ammoPackRefillCapacity >= 1:
        eventPlayer.setAmmo(ammoPackClip(), ammoPackRefillCapacity)
