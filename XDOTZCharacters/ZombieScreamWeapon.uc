// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * ZombieScreamWeapon - bridge to Screamer-zombie's attacks.  Regular fire is
 *     standard zombie grope, alt-fire is start screaming.
 *
 * @version $Rev: 2744 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    July 2004
 */
class ZombieScreamWeapon extends ZombieGropeWeapon;

/**
 * Cause pawn to start screaming
 */
function bool BotFire(bool bFinished, optional name FiringMode) {
    local ScreamerBase xScreamer;

    xScreamer = ScreamerBase( instigator );
    if ( xScreamer == None) {
        Warn( self @ "not compatible with pawn:" @ instigator );
        return false;
    }
    else {
        if (xScreamer !=None) xScreamer.StartScream();
    }
}

/**
 * Cause pawn to stop screaming
 */
function CauseAltFire() {
    local ScreamerBase xScreamer;

    xScreamer = ScreamerBase( instigator );
    if (xScreamer == None) {
        Warn( self @ "not compatible with pawn:" @ instigator );
        return;
    }
    else {
        if (xScreamer != none) xScreamer.StopScream();
    }
}


//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
}
