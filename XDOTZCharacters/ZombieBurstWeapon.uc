// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * ZombieBurstWeapon - bridge to Burster-zombie's attacks.  Regular fire is
 *     standard zombie grope, alt-fire is burst.
 *
 * @version $Rev: 2549 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    July 2004
 */
class ZombieBurstWeapon extends ZombieGropeWeapon;

/**
 * Cause pawn to burst
 */
function CauseAltFire() {
    local BursterBase burster;

    burster = BursterBase( instigator );
    if ( burster == None ) {
        Warn( self @ "not compatible with pawn:" @ instigator );
        return;
    }
    else {
        burster.DoBurst();
    }
}

//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
}
