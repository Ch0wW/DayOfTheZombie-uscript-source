// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * ZombieBurstWeapon - bridge to vomiter-zombie's attacks.  Regular fire is
 *     standard zombie grope, alt-fire is burst.
 *
 * @version $Rev: 2549 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    July 2004
 */
class ZombieVomitWeapon extends ZombieGropeWeapon;

/**
 * Cause pawn to vomit
 */
function CauseAltFire() {
    local vomiterBase vomiter;

    vomiter = VomiterBase( instigator );
    if ( vomiter == None ) {
        Warn( self @ "not compatible with pawn:" @ instigator );
        return;
    }
    else {
        vomiter.DoVomit();
    }
}

//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
}
