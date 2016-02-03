// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * ZombieGropeWeapon - a dummy weapon for zombies attacking with their
 *     bare hands.
 *
 * @version $Rev: 2549 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    July 2004
 */
class ZombieGropeWeapon extends Weapon;


//===========================================================================
// Weapons Overrides
//===========================================================================

/**
 * Not relevant for melee weapons
 */
simulated function bool HasAmmo() {
    return true;
}

/**
 * Triggers a melee/grope attack in the pawn.
 */
function bool BotFire(bool bFinished, optional name FiringMode) {
    local XDOTZPawnBase xzombie;
    //TODO this could be further simplified by just making the attack
    //     anim the pawn's fire anim, and supplying an appropriate
    //     first person anim (that will never by seen by a player).
    xzombie = XDOTZPawnBase( instigator );

    //this is transitional stuff that should be removed once we are fully
    //ported over to new pawns @@@ @@@
    if ( xzombie == None) return false;
    if (xzombie != none) {xzombie.Melee_Attack(); }
}

/**
 * ???
 */
function float RefireRate() {
    return 0;
}


//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     bMeleeWeapon=True
}
